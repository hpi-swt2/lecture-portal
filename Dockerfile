FROM ubuntu:18.04
#to suppress questions
ENV DEBIAN_FRONTEND=noninteractive
# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y build-essential curl git
RUN apt-get install -y zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH=/root/.rbenv/bin:/root/.rbenv/versions/2.5.7/bin/:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc
RUN rbenv install 2.5.7 && \
    rbenv global 2.5.7

ARG secret=wzfeguzwgfg8924rfgsdvf
ENV SECRET_KEY_BASE=${secret}
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client libpq-dev libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash
RUN apt-get install -y nodejs
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
     apt-get update && apt-get install yarn

WORKDIR /usr/src/app
COPY Gemfile* ./
ENV RAILS_ENV=production
RUN  gem install rake -v 13.0.0
RUN  gem install bundler -v 2.0.2
ENV BUNDLER_VERSION 2.0.2
RUN  bundle install --without development test

COPY . .
RUN yarn install --check-files

RUN  ./bin/rails assets:precompile
EXPOSE 3000
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true
ENV PORT=3000
CMD ["sh", "-c", "./cmd.sh"]
