FROM ruby:2.5.3
ADD .docker/web/pg.apt /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN wget --quiet -O - https://deb.nodesource.com/setup_8.x | bash -

RUN wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client-9.6 xvfb yarn

RUN wget -q -O /tmp/libjpeg-turbo8.deb http://mirrors.kernel.org/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_1.5.2-0ubuntu5_amd64.deb \
   && dpkg -i /tmp/libjpeg-turbo8.deb \
   && rm /tmp/libjpeg-turbo8.deb

RUN mkdir /app
WORKDIR /app
