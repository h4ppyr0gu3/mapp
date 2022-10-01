FROM ruby:3.1.2-bullseye

RUN apt-get update -qq && \
 apt-get install -y build-essential openssl ffmpeg \
 libssl-dev less vim libsasl2-dev git imagemagick curl

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp

ENV WORK_ROOT /root
ENV RAILS_ROOT $WORK_ROOT/app/
ENV GEM_HOME $WORK_ROOT/bundle
ENV BUNDLE_BIN $GEM_HOME/gems/bin
ENV PATH $GEM_HOME/bin:$BUNDLE_BIN:$PATH

RUN gem install bundler -v 2.3.12

WORKDIR /root/app

RUN mkdir -p $RAILS_ROOT/tmp/downloads/
RUN mkdir -p $RAILS_ROOT/tmp/downloads/idedit

ADD ./ $RAILS_ROOT
RUN bundle install

EXPOSE 3000
