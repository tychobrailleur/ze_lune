#-*- encoding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__), "models")

require 'twitter'
require 'moon'
require 'latest_tweet'
require 'pg'

class Tweet
  def initialize
    @moon = Moon.new
    @answerer = Answerer.new(@moon)
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
    @last_seen_id = LatestTweet.find
    puts "Getting tweets since #{@last_seen_id}."
    mentions = client().mentions(since_id: "#{@last_seen_id}")

    mentions.map do |status|
      puts "#{status.id} - #{status.from_user}: #{status.text}"
      @last_seen_id = status.id if status.id.to_i > @last_seen_id.to_i 
    end

    LatestTweet.update(@last_seen_id)
    mentions
  end


  def respond_to(tweet, text)
    #client().update("@#{tweet.from_user}: #{text}", {:in_reply_to_status_id => tweet.id})
  end

  def client
    @client ||= Twitter::Client.new(
      consumer_key: ENV["TWITTER_CONSUMER_KEY"],
      consumer_secret: ENV["TWITTER_CONSUMER_SECRET"],
      oauth_token: ENV["TWITTER_OAUTH_TOKEN"],
      oauth_token_secret: ENV["TWITTER_OAUTH_TOKEN_SECRET"]
    )
  end
end
