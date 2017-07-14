# this is myapp.rb referred to above
require 'sinatra'
require 'titlecase'
require 'rdiscount'
require 'redcarpet'

set :markdown, :tables => true, :layout_engine => :erb
set :environment, :production

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

get %r{/courses/?.*} do
  redirect "/diplomas", 301
end


get '/' do
  @title = "Home"
  @body_class = "home"
  body = get_body(:index)
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
  @menu_title = "Select a course:"
  if page.nil?
    page = "index"
    @title = "Diploma and Certificate Courses"
  else
    @title = "#{page.gsub('-',' ').titlecase}".gsub("Copd", "COPD")
  end
  body = get_body("diplomas/#{page}")
  @menu = Dir.glob(File.dirname(__FILE__) + "/views/diplomas/*md").map do |filename|
    next if filename.match /index.md$/
    relative_path = filename.sub(File.dirname(__FILE__) + "/views", "").sub('.md', '')
    [relative_path, filename.split("/").last.gsub('-',' ').gsub('.md', '').titlecase.gsub("Copd", "COPD")]
  end
  add_images(Dir.glob(File.dirname(__FILE__) + "/views/diplomas/*-image.*"))
  erb :sidebar_page_layout do
    markdown body
  end
end

get %r{/spirometry/?([\w-]+)?} do
  page = params[:captures] && params[:captures].first
  if page.nil?
    page = "index"
    @title = "ARTP Spirometry Courses"
  else
    @title = page
  end
  body = get_body("spirometry/#{page}")
  @menu = Dir.glob(File.dirname(__FILE__) + "/views/spirometry/*md").map do |filename|
    next if filename.match(/index.md$/)
    relative_path = filename.sub(File.dirname(__FILE__) + "/views", "").sub('.md', '')
    [relative_path, filename.split("/").last.gsub('-',' ').gsub('.md', '').titlecase.gsub("Copd", "COPD")]
  end
  add_images(Dir.glob(File.dirname(__FILE__) + "/views/spirometry/*-image.*"))
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
  body = get_body("about-us/#{page}")
  @menu = Dir.glob(File.dirname(__FILE__) + "/views/about-us/*md").map do |filename|
    next if filename.match /index.md$/
    relative_path = filename.sub(File.dirname(__FILE__) + "/views", "").sub('.md', '')
    [relative_path, filename.split("/").last.gsub('-',' ').gsub('.md', '').titlecase.gsub("Copd", "COPD")]
  end
  add_images(Dir.glob(File.dirname(__FILE__) + "/views/about-us/*-image.*"))
  erb :sidebar_page_layout do
    markdown body
  end
end

get '/:template' do
  @title = "#{params[:template].gsub('-',' ').titlecase}"
  body = get_body(params[:template])
  erb :fullpage_layout do
    markdown body
  end
end

def get_body(template_name)
  return open(File.dirname(__FILE__) + "/views/#{template_name.to_s}.md").read
end
