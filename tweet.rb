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
      config.user_agent = 'Ze Lune'

      @last_seen_id = global_config["twitter"]["last_seen_id"]
      @moon = Moon.new
    end
  end


  def process
    mentions = get_latest_mentions
    mentions.map do |status|
      if status.text =~ /phase/i
        text = translate_moon_phase(@moon.phase)
        respond_to(status, text)
      elsif status.text =~ /aphélie/i
        text = ""
      end
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
