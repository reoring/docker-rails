FROM ruby:2.3.1

ENV BUILD_PACKAGES="build-essential" \
    DEV_PACKAGES="libxml2-dev libxslt-dev libsqlite3-dev postgresql-server-dev-all libmysqlclient-dev tzdata nodejs" \
    GEMS="sqlite3 debug_inspector binding_of_caller byebug mysql2 pg puma rails bcrypt byebug therubyracer" \
    RUBY_VERSION="2.3.1"

# preinstall native extensions
RUN set -x \
  && apt-get update -y \
  && apt-get install -y $BUILD_PACKAGES $DEV_PACKAGES \
  && gem install nokogiri -- \
    --with-xml2-config=/usr/bin/xml2-config \
    --with-xslt-config=/usr/bin/xslt-config \
  && gem install $GEMS -- --use-system-libraries \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && rm -rf /usr/local/lib/ruby/gems/$RUBY_VERSION/cache/*.gem \
  && rm -rf ~/.gem \
  && rm -rf /usr/lib/libmysqld* /usr/bin/mysql*

# support Japanese input in Rails Console
ENV LANG C.UTF-8

# rails default port
EXPOSE 3000

WORKDIR /app

ONBUILD COPY Gemfile /app/
ONBUILD COPY Gemfile.lock /app/
ONBUILD RUN bundle install
