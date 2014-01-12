before '/' do
  redirect to '/authenticate' unless authenticated?
end

get '/' do
  @cohorts = recent_chicago_cohorts
  erb :index
end

get '/updated' do
  erb :updated
end

post '/update_spreadsheet' do
  selected_cohorts = recent_chicago_cohorts.select { |cohort| params[:cohorts].include?(cohort.name) }

  if update_spreadsheet(selected_cohorts)
    redirect to '/updated'
  else
    erb :index
  end
end
