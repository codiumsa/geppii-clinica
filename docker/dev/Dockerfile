FROM ruby:2.0.0-slim

MAINTAINER Jorge Ramirez "jorgeramirez1990@gmail.com"

RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends

ENV INSTALL_PATH /geppii
WORKDIR $INSTALL_PATH
ENV SRC_PATH .

COPY $SRC_PATH/Gemfile Gemfile
RUN bundle install
COPY $SRC_PATH/ .
RUN sed -i -e 's/localhost/db/g' config/database.yml
RUN sed -i -e 's/5433/5432/g' config/database.yml