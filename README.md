# MusicApp_v2(Mapp)

This is the second iteration of the music app which is using Ruby on Rails trying to follow best practices that I have learnt from my work experience.

## Installation

run `asdf install` and all the related tool versions will be installed

## Features

- Download all tracks with a single click
- Auto fill metadata using musicbrainz API
- Use Invidious instances to get youtube data
- Use Caching for the trending search page and active invidious instances
- Merge devices in the app
- Album art and metadata updating inline
- Search(online or database) or enter url
- Notifications with websockets
- Zip files for large downloads

### Upcoming Features

- capistrano for cicd
- Import and Export CSV files
- Notifications
- UX improvements
- CI/CD pipeline
- Emailing capabilities
- Auto downloading albums using MusicBrainz search interface
- Cleaning youtube titles
- extra security features
- chat room to continue playing with websockets
- maybe radio to go with chat room
- use youtube photos for more reliability
- specs need to be written
- API only interface with security in mind
- Ability to have multiple independent instances communicating

## Dependencies

I would like to continue to investigate microservice architecture so wherever possible I am trying to create a dependency in a different language to try and learn something new through this experience
The current dependencies are:
### External Services
- Postgres
- Redis
- [idedit](https://github.com/h4ppyr0gu3/idedit/)(crystal microservice) -> replaced with ffmpeg
- Docker(optional)

### Internal Services
- Sidekiq for job queues

## Contribution

Create Pull Request and we can talk

## License 

MIT

#### Ruby Version
3.1.2
#### Rails Version
7.0.3
#### Postgres Version
14.3
#### Redis Version
7.0.2

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


Adding CICD and 
available at mapp.h4ppyr0gu3.one
