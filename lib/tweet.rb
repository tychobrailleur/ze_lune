#-*- encoding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__), "models")

require 'twitter'
require 'moon'

class Tweet
  def initialize
    Twitter.configure do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.oauth_token =  ENV["TWITTER_OAUTH_TOKEN"]
      config.oauth_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"]

      @last_seen_id = ENV["TWITTER_LAST_SEEN_ID"]
      @moon = Moon.new
      @answerer = Answerer.new(@moon)
    end
  end


  def process
    mentions = get_latest_mentions
    mentions.map do |status|
      puts status.text
      text = @answerer.answer(status.text)
      respond_to(status, text) if text != nil
    end
  end
  

  def get_latest_mentions
    puts "getting tweets since #{@last_seen_id}"
    mentions = Twitter.mentions(:since_id => @last_seen_id)
    @last_seen_id = mentions.first.id if !mentions.empty?
    mentions.map do |status|
      puts "#{status.id} - #{status.from_user}: #{status.text}"
    end

    mentions
  end


  def respond_to(tweet, text)
    Twitter.update("@#{tweet.from_user}: #{text}", {:in_reply_to_status_id => tweet.id})
  end
end
