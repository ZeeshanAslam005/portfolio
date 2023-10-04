FROM ruby:3.2.2-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl imagemagick less netcat-traditional nodejs postgresql-client tzdata zbar-tools

# Install build dependencies
RUN apt-get install -y --no-install-recommends \
    build-essential git libpq-dev

# Install bundler
RUN gem install bundler:2.4.18

WORKDIR /portfolio

# Copy Gemfiles
COPY Gemfile /portfolio/Gemfile
COPY Gemfile.lock /portfolio/Gemfile.lock

# Install gems
RUN bundle install ${BUNDLER_OPTS}

# Copy project's files
COPY . /portfolio

# Expose port
EXPOSE 3000

CMD [ "bundle","exec", "puma", "config.ru"]
