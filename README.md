# ōCash Mining Pool

> **BEWARE: You should understand how this pool setup works! It involves manipulation with
> your pool's private key and password to it so it is crucial to configure it in a secure way.
> Default setup provides a secure configuration but if you change things, you can end up with
> your oCash node being open to the internet and accepting transactions from you pool's address**

This template is for setting up a simple ōCash mining pool. It uses a docker-compose to run all
needed components, stores all persistent data in docker volumes (ocash chain, pool database, DAGs...),
so containers can be removed, changed, rebuilt and rerun and until you delete these volumes, no data
is lost.

## Requirements

- linux machine
- docker CE, with docker compose plugin / standalone docker-compose - for installing these, refer
to [official Docker documentation](https://docs.docker.com/engine/install/)
- recent git
- enough disk space for storage of chain data and pool software database
- machine has to have port `30303` open for oCash node P2P to works, for accessing the pools REST api
from internet also port `4000` needs to be open (port numbers can be changed, these are for default setup)

### Components

- oCash node
- miningcore pool
- postgresql database

## Running

- prepare your Geth keystore, keep it in a secure space
- clone the pool git repository (`git clone https://github.com/blockcollider/ocash-mining-pool.git`)
- move to the repository clone (`cd ocash-mining-pool`)
- copy template configuration files to actual ones (`cp .env.example .env && cp config/config.example.json config/config.json`)
- fill in the values in `.env` to match your setup
- fill in the needed values in `config/config.json`
  - `pools.[0].address` is the only needed one for basic setup, must match `POOL_ADDRESS` in `.env`
- put your keystore in the directory you filled in `.env` file
- put your keystore password in the file you filled in `.env` file
- double check permissions on these two
- run the containers using `docker compose up`, refer to [Docker Compose documentation](https://docs.docker.com/compose/) for usage

## TLS configuration

It is strongly recommended to run the pool only with TLS encryption (pool will
serve `stratum2+ssl://` endpoint in that case).

### Testing setup

This setup will allow you to test the TLS setup, although it creates a testing
CA which is not trusted by clients by default (it's root key is not in common
CA stores)

For simpliest setup with self-signed certificate, you can use for example
[`mkcert` utility](https://github.com/FiloSottile/mkcert) (refer to you host
system package manager how to install this tool, e.g. on Debian it would be
`apt install mkcert`) for generating the certificate. Mind that miningcore
needs `pkcs12` key format, so the steps would be:

- *install the mkcert utility*
- `mkcert -install`
- `mkcert -cert-file pool-cert.pem -key-file pool-cert.key <POOL_PUBLIC_IP_ADDRESS>`
- `openssl pkcs12 -export -out pool-cert-self-signed.pfx -inkey pool-cert.key -in pool-cert.pem` (choose a password or leave blank for no password)
- put the path from previous step (option `-out`) to you `.env` file to key `POOL_TLS_CERT_PATH`
- change `pool[0].ports[0].tls` to `true`
- change `pool[0].ports[0].tlsPfxPassword` to the certifcate password

Mind that this setup is solely for testing purposes - you have to advise your clients to ignore certificate validation (e.g. `SSL_NOVERIFY=1` when using `ethminer`)

### Production setup

Simpliest way for using proper valid certificate is having a domain you own pointed to the server IP running the pool setup. Then you can use
Let's Encrypt for generating your keys, the common tool for this is [certbot](https://certbot.eff.org/).

Steps (on Debian 10):

- install certbot (`apt install certbot`)
- generate the keys with `certbot certonly --manual --preferred-challenges dns --email <your email> --domains <your domain>`
- as instructed, create the required TXT DNS record for you domain to pass the validation
- convert the key to PKCS12 format using `openssl pkcs12 -export -out pool-cert.pfx -inkey /etc/letsencrypt/live/<your domain>/privkey.pem -in /etc/letsencrypt/live/<your domain>/fullchain.pem`
the PKCS12 key is in file `pool-cert.pfx`.
- mind that the conversion step needs to be done after each key renewal, so it's better to use [certbot hooks](https://eff-certbot.readthedocs.io/en/stable/using.html#pre-and-post-validation-hooks) to this for you
- put path to converted `pool-cert.pfx` to your `.env`s `POOL_TLS_CERT_PATH`
- change `pool[0].ports[0].tls` to `true`
- change `pool[0].ports[0].tlsPfxPassword` to the certifcate password


## TODO

- [ ] Pool web UI
