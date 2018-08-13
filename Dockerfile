FROM cwds/intake_testing_base_image:2.1
LABEL application=acceptance_black_box
RUN bundle config --global frozen 1
WORKDIR /usr/src/app
ADD . $WORKDIR
RUN bundle install -j8
ENV GENERATE_TEST_REPORTS yes
ENV LC_ALL C.UTF-8
