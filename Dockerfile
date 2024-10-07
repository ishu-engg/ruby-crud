FROM ruby:3.0.6
RUN apt-get update -qq && apt-get install -y build-essential nodejs cron
ENV RAILS_ROOT /app
ENV RAILS_ENV=development
ENV RACK_ENV=development
RUN mkdir -p $RAILS_ROOT/tmp/pids
WORKDIR $RAILS_ROOT
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install 
COPY config/puma.rb config/puma.rb
COPY . .