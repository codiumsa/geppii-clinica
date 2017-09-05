FROM phusion/passenger-ruby20:0.9.19

# Set correct environment variables.
#ENV HOME /root
ENV HOME /home/app/geppii

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]


RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN apt-get -qq update
RUN apt-get -qq -y install wget
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.6 --fix-missing --no-install-recommends

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD $SRC_PATH/docker/prod/geppii.conf /etc/nginx/sites-enabled/geppii.conf

ENV INSTALL_PATH /home/app/geppii
ENV SRC_PATH .
WORKDIR $INSTALL_PATH

COPY $SRC_PATH/Gemfile Gemfile
RUN bundle install
COPY $SRC_PATH/ .
RUN sed -i -e 's/localhost/db/g' config/database.yml
RUN sed -i -e 's/5433/5432/g' config/database.yml
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace -v; exit 0
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace -v; exit 0

RUN chown app:app -R $HOME
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
