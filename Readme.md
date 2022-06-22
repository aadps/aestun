About
-----
This program tunnels Socks-5 traffic using AES-encryption between two devices.

Example usage:
--------------
Generate AES-256 key for both Desktop and VPS:
```
dd if=/dev/random bs=32 count=1 of=aeskey
```
Launch plain Socks-5 proxy on VPS,
for example with axproxy, another project here:
```
axproxy 127.0.0.1:8080
```
Then launch SocksCrypt on VPS (server-side):
```
./bin/aestun -s aeskey 0.0.0.0:12345 127.0.0.1:8080
```
Finally launch SocksCrypt on Desktop (client-side):
```
./bin/aestun -c aeskey 0.0.0.0:8082 <vps-ipv6>:8080
```
Test connection with curl on Desktop:
```
curl -x socks5h://localhost:8082 https://ipinfo.io/json -o -
```
Ports summary:
* 8080 - Plain Socks-5 server port on VPS
* 12345 - Encrypted Socks-5 traffic between devices
* 8082 - Gateway on Desktop for connections to be tunneled

How to build
------------
install dependency: openssl, then run:
```
make
```

Acknowledgments
---------------

Project branched from [sockscrypt](https://github.com/ecnx/sockscrypt).