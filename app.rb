require 'sinatra'
require 'sinatra/activerecord'


set :database, "sqlite3:///life_events_project.db"

get '/' do
  erb :"search"
end

post '/search' do
  @schools = School.search(params[:search])
  @life_events = LifeEvent.search(params[:search])
  erb :"/results"
end

post '/schools/results' do
  @schools = School.search(params[:search])
  erb :"schools/results"
end

post '/life_events/results' do
  @life_events = LifeEvent.search(params[:search])
  erb :"life_events/results"
end

get '/results' do
  erb :"results"
end

########### Schools #############







# index
get "/schools" do
  @schools = School.all
  erb :"schools/index"
end

# new
get "/schools/new" do
   erb :"schools/new"
end


# show
get "/schools/:id" do
  @school = School.find(params[:id])
  erb :"schools/show"
end

# edit
get "/schools/:id/edit" do
  @school = School.find(params[:id])
  erb :"schools/edit"
end


# create
post "/schools" do
  # clean_params = GemKeeper.launder_params(params)
  # #GemKeeper.check_url(params[:url])
  # if clean_params.length == 0
  #   redirect '/error'
  # else
  professor = Professor.new(params[:professor])
  if professor.save
    redirect '/professors'
  else
    redirect '/error'
  end
end



# update
put "/professor/:id" do
  professor_params = params[:professor]
  laundered_params = Helper.launder_params(professor_params)
  if professor_params.length == 0
    redirect '/error'
  else
    professor = Professor.find(params[:id])
    if professor.update(laundered_params)
      redirect "/professors/#{params[:id]}"
    else
      redirect "/"
    end
  end
end

# delete
delete "/professors/:id" do
  professor = Professor.find(params[:id])
  if professor.delete
    redirect "/professors"
  else
    redirect "/professors/#{params[:id]}"
  end
end

get "/error" do
  "You can't just submit a bunch of blanks."
end





########### Life Events #############



# index
get "/life_events" do
  @life_events = LifeEvent.all
  erb :"life_events/index"
end

# new
get "/life_events/new" do
   erb :"life_events/new"
end


# show
get "/life_events/:id" do
  @life_event = LifeEvent.find(params[:id])
  erb :"life_events/show"
end

# edit
get "/life_events/:id/edit" do
  @life_event = LifeEvent.find(params[:id])
  erb :"life_events/edit"
end


# create
post "/life_events" do
  # clean_params = GemKeeper.launder_params(params)
  # #GemKeeper.check_url(params[:url])
  # if clean_params.length == 0
  #   redirect '/error'
  # else
  life_event = LifeEvent.new(params[:life_event])
  if life_event.save
    redirect '/life_events'
  else
    redirect '/error'
  end
end

# update
put "/life_events/:id" do
  life_events_params = params[:life_event]
  laundered_params = Helper.launder_params(life_events_params)
  if laundered_params.length == 0
    redirect '/error'
  else
    event = LifeEvent.find(params[:id])
    if event.update(laundered_params)
      redirect "/life_events/#{params[:id]}"
    else
      redirect "/life_events"
    end
  end
end

# delete
delete "/life_events/:id" do
  school = LifeEvent.find(params[:id])
  if school.delete
    redirect "/life_events"
  else
    redirect "/life_events/#{params[:id]}"
  end
end

get "/error" do
  "You can't just submit a bunch of blanks."
end


class School < ActiveRecord::Base

  def self.search(search_data)
    type = search_data[:type]
    criteria = search_data[:criteria]
    if type.downcase == "year"
      School.where("start_year <= ? AND end_year >= ?", criteria, criteria)
    elsif type.downcase == "lifeevent"
      return
    else
      School.where("#{type} == ? OR #{type} == ? OR #{type} == ?", criteria, criteria.capitalize, criteria.split(" ").map(&:capitalize).join(" "))
    end
  end
end

class LifeEvent < ActiveRecord::Base
  def self.search(search_data)
    type = search_data[:type]
    criteria = search_data[:criteria]
      LifeEvent.where("#{type} == ? OR #{type} == ?", criteria, criteria.capitalize)
  end
end


module Helper
  def self.launder_params(params)
    params.select { |k, v| v != '' }
  end

  def self.check_url(address)
    address =~ URI::regexp(["ftp", "http", "https"])
  end
end