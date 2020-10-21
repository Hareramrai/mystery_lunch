#!/bin/sh

rm -f tmp/pids/server.pid

# setup database and start puma
RAILS_ENV=$RAILS_ENV bundle exec rake db:migrate
RAILS_ENV=$RAILS_ENV bundle exec puma -C config/puma.rb
