FROM ruby:2.7.1

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev &&\
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y nodejs yarn

# rails
RUN gem install rails bundler
COPY Gemfile Gemfile.lock ./
WORKDIR /usr/src/app
# RUN bundle config unset frozen
RUN bundle install

COPY . .
# CMD ["./your-daemon-or-script.rb"]
