Project setup
================

## Environment setup

1. Install [docker](https://github.com/Yelp/docker-compose/blob/master/docs/install.md)
2. Build containers `docker-compose build`
3. Migrate database `docker-compose run app bundle exec thor db:migrate`
4. Launch containers `docker-compose up`
5. Test shorty
```bash
  curl -i -X POST -H 'Content-Type: application/json' -d '{"url": "http://example.com", "shortcode": "123456"}' localhost:9292/shorten
  curl -i localhost:9292/123456
  curl -i localhost:9292/123456/stats
```

## Testing

1. Migrate test db `docker-compose run -e RACK_ENV=test app bundle exec thor db:migrate`
2. Run tests `docker-compose run app bundle exec rspec`
