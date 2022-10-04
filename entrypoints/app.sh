#!/bin/bash
#
source /root/app/.env

bundle exec rails db:migrate RAILS_ENV=production

kill -9 $(cat /root/app/tmp/pids/server.pid)

rm -f /root/app/tmp/pids/server.pid

mkdir -p /root/app/tmp/downloads

bundle exec rails server -b 0.0.0.0 -p 3000 -e production


