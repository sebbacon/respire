# this is myapp.rb referred to above
require 'sinatra'
require 'titlecase'
require 'rdiscount'
require 'debugger'
set :markdown, :layout_engine => :erb

helpers do
  def partial(page, options={})
    erb page, options.merge!(:layout => false)
  end
end

get '/' do
  erb :index, :locals => {
    :title => 'Open Company Data Index',
    :tab => 'home'
  }
end

get '/courses/:page' do |page|
  @title = "#{page.gsub('-',' ').titlecase}"
  @tab = page
  @menu = []
  erb :sidebar_page_layout do
    markdown "courses/#{page}".to_sym
  end
end

get %r{/about-us/?([\w-]+)?} do
  page = params[:captures] && params[:captures].first
  puts "==#{page}##"
  if page.nil?
    page = "index"
    @title = "About us"
  else
    @title = "#{page.gsub('-',' ').titlecase}"
  end
  @menu = Dir.glob(File.dirname(__FILE__) + "/views/about-us/*md").map do |filename|
    next if filename.match /index.md$/
    relative_path = filename.sub(File.dirname(__FILE__) + "/views", "").sub('.md', '')
    [relative_path, filename.split("/").last.gsub('-',' ').gsub('.md', '').titlecase]
  end
  erb :sidebar_page_layout do
    markdown "about-us/#{page}".to_sym
  end
end
