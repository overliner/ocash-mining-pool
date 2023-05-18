FROM ethereum/client-go:v1.11.5

RUN apk add --no-cache curl

WORKDIR /tmp/

RUN curl https://oland.s3.us-east-2.amazonaws.com/ocashtestnetgenesis.json -o ocashtestnetgenesis.json

RUN geth --verbosity 5 init ./ocashtestnetgenesis.json
