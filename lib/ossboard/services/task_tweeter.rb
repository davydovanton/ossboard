class TaskTwitter
   def self.call(task)
    new.call(task)
  end

  def call(task)
    tweet text(task)
  end

  def link_to_task(task_id)
    "http://www.ossboard.org/tasks/#{task_id}"
  end

  def text(task)
    tag_and_link = "#ossboard #{link_to_task(task.id)}"
    length_left = TWEET_MAX_LENGTH - tag_and_link.size
    title = task.title
    title = "#{title[0..length_left]}..." if title.size > length_left
    "#{title} #{tag_and_link}"
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
  end

  def tweet(text)
    return unless Hanami.env?(:production)
    twitter_client.update(text)
  end

  # Keep extra 5 symbols for spaces and ...
  TWEET_MAX_LENGTH = 135
end
