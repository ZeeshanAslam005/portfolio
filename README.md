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

## Development

### Initial Setup

To set up the application locally, run:
```
docker/dev-setup.sh
```

You can also reset the application by running:
```
docker/dev-setup.sh --reset
```


### Start Application

To start all required services and the webserver, run:
```
docker-compose up
```

```
docker exec -it portfolio-web-1 /bin/bash
```
