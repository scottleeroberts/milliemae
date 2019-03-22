FROM ruby:2.3.6
RUN wget --quiet -O - https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs bcrypt

RUN mkdir /milliemae
WORKDIR /milliemae
COPY Gemfile /milliemae/Gemfile
COPY Gemfile.lock /milliemae/Gemfile.lock
RUN bundle install
COPY . /milliemae
