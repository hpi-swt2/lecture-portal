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
RUN bundle install --without development test

COPY . .
RUN yarn install --check-files
# We need a database to precompile the assets. Compiling at run time is impossible; node fails because there is not enough memory.
# Obviously, we do not want to connect to the real production database from whatever build server we run on.
# So we exchange the real databas econfiguration that points to the Heroku database with one that points to a SQLite database we can quickly create on ephemeral storage.
RUN cp ./config/database.yml ./config/database_real.yml
RUN cp ./config/database_travis_build.yml ./config/database.yml
# db schema needs to be created, so run migrations first
RUN ./bin/rails db:migrate
# now assets can be compiled
RUN ./bin/rails assets:precompile
# revert the change so we speak to the production database later
RUN cp ./config/database_real.yml ./config/database.yml
EXPOSE 3000
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT=3000
CMD ["sh", "-c", "./cmd.sh"]
