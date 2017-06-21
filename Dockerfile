FROM ruby:2.4.0
LABEL application=acceptance_black_box
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
RUN bundle install

ENV USE_XVFB true
ENV GENERATE_TEST_REPORTS yes
