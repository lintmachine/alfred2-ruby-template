#!/usr/bin/env ruby
# encoding: utf-8

require "base64"

puts Base64.decode64(ARGF.read)
