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

## TODO

- [ ] stratum TLS
- [ ] Pool web UI
