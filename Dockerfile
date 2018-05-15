FROM ruby:1.9.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && mkdir /myapp

WORKDIR /myapp
ADD Gemfile .
ADD Gemfile.lock .
RUN bundle install
ADD . .
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
RUN rm -f tmp/pids/server.pid 