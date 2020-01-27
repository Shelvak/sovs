FROM ruby:2.6-alpine3.11

# Patch to get global bins
ENV BUNDLE_BIN="$GEM_HOME/bin"
ENV PATH $BUNDLE_BIN:$PATH
ENV RAILS_ENV production
RUN mkdir -p "$BUNDLE_BIN"
RUN chmod 777 "$BUNDLE_BIN"

RUN echo "gem: --no-rdoc --no-ri" >> ~/.gemrc \
    && apk --update add --virtual build-dependencies build-base postgresql-dev \
    && apk --update add libpq bash libxml2 libxml2-dev libxml2-utils libxslt \
                        openssl zlib tzdata git openssh file imagemagick \
                        nodejs npm vim \
    && gem install bundler --no-document

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem update --system && \
    bundle config set deployment 'true' && \
    bundle install --jobs 8 && \
    apk del build-dependencies

ADD . ./
COPY config/app_config.example.yml config/app_config.yml
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]
