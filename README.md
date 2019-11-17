# broolik-worker

Crystal Lang implementation for the Link Checker

## TODO

- [x] Use DB Connection Pool on Sidekiq instead of create new one
- [ ] Auto-set connection pool from number of workers to use
- [ ] Add tests/development env example
- [ ] Where to put code in the monolith Rails Repo
      (Ideas: app/crystal, engines/background.cr, app/workers.cr)
- [ ] Deployment on Heroku with Ruby on Rails

## Installation

```bash
crystal build src/sidekiq.cr -o bin/sidekiq.cr --release
``` 

## Usage

```bash
bin/sidekiq.cr -q worker.cr -c 100 -e production
```

## Development

```bash
crystal spec
```

## Contributors

- [Paul Keen](https://github.com/pftg) - creator and maintainer
