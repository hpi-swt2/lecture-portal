FROM ruby:2.5.1
ARG secret=wzfeguzwgfg8924rfgsdvf
ENV SECRET_KEY_BASE=${secret}
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client libpq-dev \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN apt-get install -y nodejs
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
     apt-get update && apt-get install yarn

WORKDIR /usr/src/app
COPY Gemfile* ./
ENV RAILS_ENV=production
RUN gem install rake -v 13.0.0
RUN gem install bundler -v 2.0.2
ENV BUNDLER_VERSION 2.0.2
# see https://github.com/sass/sassc-ruby/issues/146
RUN gem install sassc -- --disable-march-tune-native
RUN gem install sqlite3
RUN bundle install --without development test

COPY . .
RUN yarn install --check-files
ENV RAILS_ENV=TEST
RUN ./bin/rails db:migrate
RUN ./bin/rails assets:precompile
ENV RAILS_ENV=production
EXPOSE 3000
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT=3000
CMD ["sh", "-c", "./cmd.sh"]
