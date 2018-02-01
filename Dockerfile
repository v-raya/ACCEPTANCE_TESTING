FROM ruby:2.4.0
LABEL application=acceptance_black_box
RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    iceweasel \
    libnss3

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

RUN bundle config --global frozen 1

WORKDIR /usr/src/app
ADD . $WORKDIR
RUN bundle install

ENV GENERATE_TEST_REPORTS yes
ENV LC_ALL C.UTF-8
