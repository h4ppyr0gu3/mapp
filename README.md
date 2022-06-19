# MusicApp_v2(Mapp)

This is the second iteration of the music app which is using Ruby on Rails trying to follow best practices that I have learnt from my work experience.

## Features

- Download all tracks with a single click
- Auto fill metadata using musicbrainz API
- Use Invidious instances to get youtube data
- Use Caching for the trending search page and active invidious instances
- Merge devices in the app
- Album art and metadata updating inline
- Search(online or database) or enter url

### Upcoming

- Notifications
- UX improvements
- CI/CD pipeline

## Dependencies

I would like to continue to investigate microservice architecture so wherever possible I am trying to create a dependency in a different language to try and learn something new through this experience
The current dependencies are:
- Postgres
- Redis
- [idedit](https://github.com/h4ppyr0gu3/idedit/)(crystal microservice)
- Docker(optional)

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

