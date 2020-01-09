FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y postgresql-client
ENV APP_HOME /shorty
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME
ENV BUNDLE_PATH /bundle
RUN bundle install
CMD tail -f /dev/null
