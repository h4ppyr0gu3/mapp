#!/bin/bash

bundle exec rails db:create RAILS_ENV=docker
bundle exec rails db:migrate RAILS_ENV=docker

echo "2f28c42b30b5613178b01aee71776139" >> /root/app/config/master.key

kill -9 $(cat /root/app/tmp/pids/server.pid)

rm -f /root/app/tmp/pids/server.pid

mkdir -p /root/app/tmp/downloads

bundle exec rails server -b 0.0.0.0 -p 3000 -e docker


