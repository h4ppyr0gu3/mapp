#!/bin/bash

rails db:create RAILS_ENV=docker
rails db:migrate RAILS_ENV=docker

export SECRET_KEY_BASE=$(rake secret)

kill -9 $(cat /root/app/tmp/pids/server.pid)

mkdir -p /root/app/tmp/downloads

bundle exec rails server -b 0.0.0.0 -p 3000 -e docker


