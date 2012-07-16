$:.unshift File.join(File.dirname(__FILE__), "models")
$:.unshift File.join(File.dirname(__FILE__), "lib")

require 'rubygems'
require 'sinatra'
require 'rufus/scheduler'
require 'helpers'
require 'tweet'
require 'yaml'
require 'moon'


global_config = YAML.load_file(File.join(File.dirname(__FILE__), "config", "production.yml"))


scheduler = Rufus::Scheduler.start_new
tweet_handler = Tweet.new(global_config)
scheduler.every '2m' do
  tweet_handler.process
end

get '/tasks' do
  scheduler.all_jobs.to_s
end

get '/phase' do 
  translate_moon_phase(Moon.new.phase)
end

get '/phase/:year/:month/:day' do |y,m,d|
  t = Time.new(y, m, d)
  translate_moon_phase(Moon.new(t).phase)
end
