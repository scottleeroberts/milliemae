FROM postgres:9.6

ADD docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

RUN apt-get update -qq && apt-get install -y openssh-client
