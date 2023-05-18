FROM postgres

RUN apt-get update && apt-get install -y curl wget && apt-get clean

RUN curl https://raw.githubusercontent.com/oliverw/miningcore/master/src/Miningcore/Persistence/Postgres/Scripts/createdb.sql -o /docker-entrypoint-initdb.d/001-createdb.sql
# Only necessary for performance boost in Multipool-Cluster setup
# RUN curl https://raw.githubusercontent.com/oliverw/miningcore/master/src/Miningcore/Persistence/Postgres/Scripts/createdb_postgresql_11_appendix.sql -o /docker-entrypoint-initdb.d/002-createdb_postgresql_11_appendix.sql
