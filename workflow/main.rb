#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require "bundler/setup"
require "alfred"
require "plist"
require "base64"

user_snippets_directory = File.expand_path(ENV['USER_XCODE_SNIPPETS']) # '/Users/cdann/Library/Developer/Xcode/UserData/CodeSnippets'

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback

  snippet_files = Dir["#{user_snippets_directory}/*.codesnippet"]
  
  snippet_files.each do |snippet_file|

    snippet_plist = Plist::parse_xml("#{snippet_file}")

    fb.add_item(
      {
          :uid      => snippet_plist['IDECodeSnippetIdentifier'],
          :title    => snippet_plist['IDECodeSnippetTitle'],
          :subtitle => snippet_plist['IDECodeSnippetSummary'],
          :arg      => Base64.encode64(snippet_plist['IDECodeSnippetContents']),
          :valid    => "yes"
      }
    )
  end

  if ARGV[0].eql? "failed"
    alfred.with_rescue_feedback = true
    raise Alfred::NoBundleIDError, "Wrong Bundle ID Test!"
  end

  puts fb.to_xml(ARGV)
end
