#!/usr/bin/env ruby

gem 'tweetstream', '~> 2.6'
require 'tweetstream'

TweetStream.configure do |config|
  # Put your own twitter config values here
  # https://dev.twitter.com/oauth/overview/application-owner-access-tokens
  config.consumer_key       = "Put your consumer key"
  config.consumer_secret    = "Put your consumer secret"
  config.oauth_token        = "Put your access token"
  config.oauth_token_secret = "Put your access token secret"
  config.auth_method        = :oauth
end

BLACKLIST = %w(https that this with your have from some when they here just what about want).to_set

def count_twitter_stream_words(minutes)
  word_count = Hash.new(0)
  five_minutes_later = Time.now + minutes * 60

  TweetStream::Client.new.sample do |status|
    if status.lang == 'en'
      status.text.downcase.split(/\W+/).each do |word|
        next if word.length < 4
        next if BLACKLIST.include?(word)
        word_count[word] += 1
      end
    end

    break if Time.now >= five_minutes_later
  end

  return word_count
end

puts count_twitter_stream_words(5).sort_by {|k, v| v}.reverse.first(10).to_h
