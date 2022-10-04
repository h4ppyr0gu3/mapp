FROM ruby:3.1.2-bullseye

ENV WORK_ROOT /root
ENV RAILS_ROOT $WORK_ROOT/app/
ENV GEM_HOME $WORK_ROOT/bundle
ENV BUNDLE_BIN $GEM_HOME/gems/bin
ENV PATH $GEM_HOME/bin:$BUNDLE_BIN:$PATH

RUN gem install bundler -v 2.3.12

WORKDIR /root/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

RUN apt-get update -qq && \
 apt-get install -y build-essential openssl ffmpeg \
 libssl-dev less vim libsasl2-dev git imagemagick curl npm nodejs

RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp

EXPOSE 3000
RUN npm install
ADD ./ $RAILS_ROOT


# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
# RUN export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# RUN nvm install 16

RUN mkdir -p $RAILS_ROOT/tmp/downloads/
RUN mkdir -p $RAILS_ROOT/tmp/downloads/idedit
