#!/bin/bash

source .env

bundle exec sidekiq -e production

