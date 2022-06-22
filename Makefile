# SocksCrypt Makefile
INCLUDES=-I include -DEPOLL_CREATE_ANY
INDENT_FLAGS=-br -ce -i4 -bl -bli0 -bls -c4 -cdw -ci4 -cs -nbfda -l100 -lp -prs -nlp -nut -nbfde -npsl -nss

OBJS = \
	bin/startup.o \
	bin/proxy.o \
	bin/crypto.o \

all: host

internal: prepare
	@echo "  CC    src/startup.c"
	@$(CC) $(CFLAGS) $(INCLUDES) src/startup.c -o bin/startup.o
	@echo "  CC    src/proxy.c"
	@$(CC) $(CFLAGS) $(INCLUDES) src/proxy.c -o bin/proxy.o
	@echo "  CC    src/crypto.c"
	@$(CC) $(CFLAGS) $(INCLUDES) src/crypto.c -o bin/crypto.o
	@echo "  LD    bin/aestun"
	@$(LD) -o bin/aestun $(OBJS) $(LDFLAGS) -lssl -lcrypto

prepare:
	@mkdir -p bin

host:
	@make internal \
		CC=gcc \
		LD=gcc \
		CFLAGS='-c -Wall -Wextra -O3 -ffunction-sections -fdata-sections -Wstrict-prototypes' \
		LDFLAGS='-Wl,--gc-sections -Wl,--relax'

debug:
	@make internal \
		CC=gcc \
		LD=gcc \
		CFLAGS='-c -Wall -Wextra -O3 -ffunction-sections -fdata-sections -Wstrict-prototypes -DVERBOSE_MODE -g' \
		LDFLAGS='-Wl,--gc-sections -Wl,--relax -g'

nodaemon:
	@make internal \
		CC=gcc \
		LD=gcc \
		CFLAGS='-c -Wall -Wextra -O2 -ffunction-sections -fdata-sections -Wstrict-prototypes -DNO_DAEMON' \
		LDFLAGS='-s -Wl,--gc-sections -Wl,--relax'

post:
	@echo "  STRIP sockscrypt"
	@sstrip bin/sockscrypt
	@echo "  UPX   sockscrypt"
	@upx bin/sockscrypt
	@echo "  LCK   sockscrypt"
	@perl -pi -e 's/UPX!/EsNf/g' bin/sockscrypt
	@echo "  AEM   sockscrypt"
	@nogdb bin/sockscrypt

clean:
	@echo "  CLEAN ."
	@rm -rf bin

analysis:
	@scan-build make
	@cppcheck --force */*.h
	@cppcheck --force */*.c
