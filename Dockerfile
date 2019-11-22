FROM ruby:2.5.1
ARG secret=wzfeguzwgfg8924rfgsdvf
ENV SECRET_KEY_BASE=${secret}
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN apt-get install -y nodejs
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
     apt-get update && apt-get install yarn

WORKDIR /usr/src/app
COPY Gemfile ./
ENV RAILS_ENV=production
RUN gem install rake -v 13.0.0
RUN gem install bundler -v 2.0.2
ENV BUNDLER_VERSION 2.0.2
RUN bundle install --system

COPY . .
RUN yarn install --check-files
RUN ./bin/rails webpacker:install && \
    ./bin/rails webpacker:install:react && \
    ./bin/rails generate react:install && \
    ./bin/rails webpacker:install:typescript

RUN ./bin/rails assets:precompile
EXPOSE 3000
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT=3000
CMD ["sh", "-c", "./cmd.sh"]
