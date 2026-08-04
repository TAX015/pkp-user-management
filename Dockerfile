FROM ruby:3.4-alpine

# Install build dependencies and runtime necessities
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    tzdata \
    git \
    gcompat \
    bash

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install foreman for bin/dev support
RUN gem install foreman

COPY . .

RUN chmod +x bin/*

EXPOSE 3000

CMD ["bin/dev"]