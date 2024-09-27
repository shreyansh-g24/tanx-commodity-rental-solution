# tanx-commodity-rental-solution

## Add dependencies

1. Install the ruby version manager of your choice such as `rbenv`.
2. Install the required `ruby` version.
3. Install `PostgreSQL`.
4. Install `redis`.

## Set up the rails application

Run the following steps to set up the application on local.

```bash
bundle install
cp config/database.yml.sample config/database.yml
bundle exec rails db:create
bundle exec rails db:migrate
gem install foreman
foreman -f Procfile.dev
```

You can run the Rails and Sidekiq servers together with `foreman` or choose to run them individually in different terminals.

## Use the application
Use `Postman` or any other API testing tool of your choice to interact with the application on `localhost:3000`.

## Postman collection
Import the [exported Postman collection](./docs/tanx-commodity-rental-solution.postman_collection.json) to quickly get started with testing.
