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

before do
  this_year = Date.today.year
  if this_year == "2013"
    @copyright_year = "2013"
  else
    @copyright_year = "2013 - #{this_year}"
  end
end

def add_images(files)
  file = files.first
  return if !file
  file = file.sub(File.dirname(__FILE__) + "/views", "")
  @image_tag = "<img src='#{file}' alt='post image' class='img-rounded pull-left illustration'>"
end

get '/' do
  @title = "Respire"
  @intro, body = get_intro_and_body(:index)
  erb :homepage_layout do
    erb body
  end
end

get %r{(.*-image.*$)} do
  path = params[:captures].first
  content_type "image/#{path.split('.').last}"
  open(File.dirname(__FILE__) + "/views/#{path}") do |file|
    file.read
  end
end

get %r{/diplomas/?([\w-]+)?} do
  page = params[:captures] && params[:captures].first
  puts "==#{page}##"
  @menu_title = "Select a diploma:"
  if page.nil?
    page = "index"
    @title = "Diplomas"
  else
    @title = "#{page.gsub('-',' ').titlecase}"
  end
  @intro, body = get_intro_and_body("diplomas/#{page}")
  @menu = Dir.glob(File.dirname(__FILE__) + "/views/diplomas/*md").map do |filename|
    next if filename.match /index.md$/
    relative_path = filename.sub(File.dirname(__FILE__) + "/views", "").sub('.md', '')
    [relative_path, filename.split("/").last.gsub('-',' ').gsub('.md', '').titlecase]
  end
  add_images(Dir.glob(File.dirname(__FILE__) + "/views/diplomas/*-image.*"))
  erb :sidebar_page_layout do
    markdown body
  end
end

get %r{/about-us/?([\w-]+)?} do
  page = params[:captures] && params[:captures].first
  if page.nil?
    page = "index"
    @title = "About us"
  else
    @title = "#{page.gsub('-',' ').titlecase}"
  end
  @menu_title = "Menu"
  @intro, body = get_intro_and_body("about-us/#{page}")
  location =
  @menu = Dir.glob(File.dirname(__FILE__) + "/views/about-us/*md").map do |filename|
    next if filename.match /index.md$/
    relative_path = filename.sub(File.dirname(__FILE__) + "/views", "").sub('.md', '')
    [relative_path, filename.split("/").last.gsub('-',' ').gsub('.md', '').titlecase]
  end
  add_images(Dir.glob(File.dirname(__FILE__) + "/views/about-us/*-image.*"))
  erb :sidebar_page_layout do
    markdown body
  end
end

get '/:template' do
  @title = "#{params[:template].gsub('-',' ').titlecase}"
  @intro, body = get_intro_and_body(params[:template])
  erb :fullpage_layout do
    markdown body
  end
end


def get_intro_and_body(template_name)
  text = open(File.dirname(__FILE__) + "/views/#{template_name.to_s}.md").read.split("\n")
  intro = nil
  text.each do |para|
    if !para.match(/^#/)
      intro = para
      break
    end
  end
  body = text - [intro]
  return intro, body.join("\n")
end
