FROM ruby:2.5.1-alpine

COPY Gemfile /app/
WORKDIR /app

RUN apk add --no-cache build-base libxml2-dev libxslt-dev

RUN gem install bundler && \
    bundle install -j4

COPY docker-entrypoint.sh gdrive.rb httpd.rb /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["httpd"]
