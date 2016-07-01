FROM ruby:2.3.1-alpine

ENV BUILD_PACKAGES="build-base" \
    DEV_PACKAGES="libxml2-dev libxslt-dev sqlite-dev mariadb-dev tzdata nodejs" \
    GEMS="nokogiri sqlite3 debug_inspector binding_of_caller byebug mysql2 puma rails" \
    RUBY_VERSION="2.3.1"

# preinstall native extensions
RUN set -x \
  && apk --update --upgrade add $BUILD_PACKAGES $DEV_PACKAGES \
  && gem install $GEMS -- \
    --with-xml2-config=/usr/bin/xml2-config \
    --with-xslt-config=/usr/bin/xslt-config \
  && apk del $BUILD_PACKAGES \
  && find / -type f -iname \*.apk-new -delete \
  && rm -rf /var/cache/apk/* \
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
