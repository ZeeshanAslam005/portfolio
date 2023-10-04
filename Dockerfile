FROM ruby:3.2.2-alpine

RUN apk update && \
    apk add --no-cache build-base postgresql-dev nodejs tzdata


WORKDIR /portfolio/app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

ADD . /portfolio/app

ARG DEFAULT_PORT 3000

EXPOSE ${DEFAULT_PORT}

CMD [ "bundle","exec", "puma", "config.ru"]