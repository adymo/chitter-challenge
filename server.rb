require 'sinatra/base'
require 'data_mapper'
# require_relative 'lib/hashtag'
# require_relative 'lib/post'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/chitter_#{env}")
require_relative 'lib/post'
require_relative 'lib/hashtag'
DataMapper.finalize
DataMapper.auto_upgrade!

class Chitter < Sinatra::Base
  get '/' do
   @posts = Post.all
   erb :index
  end

  post '/posting' do
    username = params['username']
    message = params['message']
    post = Post.create(username: username, message: message)
    params['hashtag'].split(/\s+/).each do |hashtag|
      post.hashtags.create(text: hashtag)
    end
    redirect to ('/')
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
