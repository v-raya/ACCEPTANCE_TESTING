#!/usr/bin/env ruby
# frozen_string_literal: true

Dir.chdir('bubble') do
  `docker-compose -f docker-compose.bubble.yml up -d nginx intake`
  `docker-compose -f docker-compose.bubble.yml build acceptance_testing`
  exec('docker-compose -f docker-compose.bubble.yml up acceptance_testing')
end

