#-*- encoding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__), "models")

require 'twitter'
require 'moon'
require 'helpers'

class Tweet
  def initialize(global_config)
    Twitter.configure do |config|
      config.consumer_key = global_config["twitter"]["consumer_key"]
      config.consumer_secret = global_config["twitter"]["consumer_secret"]
      config.oauth_token =  global_config["twitter"]["oauth_token"]
      config.oauth_token_secret = global_config["twitter"]["oauth_token_secret"]
 #     config.user_agent = 'Ze Lune'

      @last_seen_id = global_config["twitter"]["last_seen_id"]
      @moon = Moon.new
    end
  end


  def process
    mentions = get_latest_mentions
    mentions.map do |status|
      puts status.text
      question = status.text.encode('UTF-8')

      text = nil
      if question =~ /phase/i
        text = translate_moon_phase(@moon.phase)
      elsif question =~ /aphélie/i
        text = "405 696 km"
      elsif question =~ /périhélie/i
        text = "363 104 km"
      elsif question =~ /premier\s+homme.*march.*/i
        text = "Neil Armstrong, le 21 juillet 1969, à 2 h 56 UTC — http://tinyurl.com/l9lafy"
      end

      respond_to(status, text) if text != nil
    end
  end
  

  def get_latest_mentions
    puts "getting twwets ince #{@last_seen_id}"
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
