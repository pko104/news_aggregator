require 'sinatra'
require 'pry'

csv_file = File.read("articles.csv").split("\n")
  no_repeaturl = []
  no_repeat_art = []
   csv_file.each do |news|
     elements = news.split(",")
     no_repeaturl << elements[1]
     no_repeat_art << elements[0]

  end

get '/' do

erb :index
end

get '/articles/new' do

erb :new
end

get '/articles' do

  @csv_file = File.read("articles.csv").split("\n")

erb :articles
end

post '/articles' do

  @title = params["title"]
  @url = params["url"]
  @description = params["description"]

  if !@title.empty? && !@url.empty? && !(no_repeaturl.include?@url) && !(no_repeat_art.include?@title) && @description.length >= 20
    File.open("articles.csv", "a"){|file| file.puts "#{@title},#{@url},#{@description}"}
    redirect '/articles'
  else
    @error_messages = []
    @error_messages << "You must enter a title." if @title.empty?
    @error_messages << "URL has already been submitted." if no_repeaturl.include?@url
    @error_messages << "Title has already been submitted." if no_repeat_art.include?@title
    @error_messages << "You must enter a URL." if @url.empty?
    @error_messages << "Description must be 20 characters or longer." if @description.length < 20

    #@title = @title
    #@url = @url
    #@description = @description
    erb :new
  end

end
