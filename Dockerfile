FROM ruby:2.5.1

# Adds Debian Stretch repository to the sources list resolving errors due to missing Release files
RUN echo "deb http://deb.debian.org/debian buster main" > /etc/apt/sources.list

# Add necessary GPG keys (public key)
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138 0E98404D386FA1D9 DCC9EFBF77E11517

RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs \
  && apt-get clean all \
  && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV RAILS_LOG_TO_STDOUT=true

RUN mkdir /app

# Copy these over first so that we can rely on Docker to intelligently run or not run bundle install based
# on whether these files have changed or not.
COPY Gemfile Gemfile.lock /app/
WORKDIR /app
RUN bundle install

# Copy over the rest of the app's files
COPY . /app

CMD ["bundle", "exec", "rails", "s", "-p", "3005", "-b", "0.0.0.0"]
