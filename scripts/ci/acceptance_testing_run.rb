#!/usr/bin/env ruby
# frozen_string_literal: true

Dir.chdir('bubble') do
  `docker-compose -p acceptance_bubble_#{ENV['BUILD_NUMBER']} -f docker-compose.bubble.yml up -d nginx intake`
  `docker-compose -p acceptance_bubble_#{ENV['BUILD_NUMBER']} -f docker-compose.bubble.yml build acceptance_testing`
  exec("docker-compose -p acceptance_bubble_#{ENV['BUILD_NUMBER']} -f docker-compose.bubble.yml up --exit-code-from acceptance_testing acceptance_testing")
end

