FROM ruby:2.7.2
LABEL maintainer="First <developer@first.io>"

RUN mkdir -p /root/.ssh
COPY config/docker_profile /root/.profile

ENV WORK_DIR /usr/lib/heaven

RUN mkdir -p $WORK_DIR

COPY Gemfile $WORK_DIR/Gemfile
COPY Gemfile.lock $WORK_DIR/Gemfile.lock
RUN gem install bundler -v '1.17.3'
RUN cd $WORK_DIR && bundle install


RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get install -y yarn && \
    yarn global add expo-cli && \
    apt-get install -y awscli && \
    rm -rf /var/lib/apt/lists/*

COPY . $WORK_DIR

WORKDIR $WORK_DIR
RUN bundle exec rails db:environment:set RAILS_ENV=production
EXPOSE 80

ENTRYPOINT ["bundle", "exec"]
CMD ["unicorn", "-p", "80", "-c", "config/unicorn.rb"]
