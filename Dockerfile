FROM ruby:2.3
RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    iceweasel \
    xvfb \
    qt5-default \
    libqt5webkit5-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-tools \
    gstreamer1.0-x

RUN bundle config --global frozen 1

WORKDIR /usr/src/app
ADD . $WORKDIR
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

ENV USE_XVFB true
ENV GENERATE_TEST_REPORTS yes
