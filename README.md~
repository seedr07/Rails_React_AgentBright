## Running on local development machine

### Add configuration files
* Copy `config/database.yml.pgapp` and rename copy to `config/database.yml`
* Copy `.sample.env` and rename copy to `.env`

### Setup packages and database

#### Get started quickly:
```sh
$ bin/setup
```

#### Manual setup
* Install npm packages
  ```sh
  $ npm install
  ```

* Install rubygems
  ```sh
  $ bundle install
  ```

* Create database
  ```sh
  $ bundle exec rake db:create db:migrate
  ```

* Add sample data
  ```sh
  $ bundle exec rake setup_sample_data
  ```

_Note: If you have issues installing the *capybara-webkit* gem, follow these instructions: https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit_

### Starting the server

To start the server for Rails development:

```sh
$ foreman start -f Procfile.static
```

To start the server for React development:

```sh
$ foreman start -f Procfile.dev
```

### Running tests
We use minitest for testing.

``` ruby
# to execute all tests
rails test

# to execute tests in models
rails test:models

# to execute tests in controllers
rails test:controllers

# running an individual test file
rails test test/models/comment_test.rb
```

### Sensitive Info (eg API keys)

- Create environment variables and values in Heroku
- Add environment variables to *config/secrets.yml*

## Additional Information
#### Markup
* We currently use Bootstrap 3, but are switching to Semantic-UI

#### Javascript
* Do not use Coffeescript, only Javascript
* Turbolinks 5 is enabled
* Do not use IDs or classes for selectors. Use `data` attributes instead

#### Server
* We use Puma in all environments

#### Plugins
* For Email:
  * Mandrill to send messages
  * Mailgun to receive messages to `agentbright.me` accounts - [Using Mailgun](https://github.com/agentbright/documentation/tree/master/development/features/lead_email_parsing/using_mailgun)
  * Nylas Cloud to sync with user email accounts
* We use memcached for caching
* Simpleform for forms - [Using Simpleform in AgentBright](https://github.com/agentbright/documentation/tree/master/development/front_end/simple_form)
* Delayed Job to handle background jobs
* CircleCI for continuous testing
* Devise for authentication
* Administrate as an admin framework

#### In Production
* Hosted on Heroku
* PostgreSQL database
* Amazon Cloudfront as an asset CDN
* Amazon S3 for file uploads
* Caching via memcached on Memcached Cloud
* Monitoring with Honeybadger
