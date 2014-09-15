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
  if params[:cohorts]
    selected_cohorts = recent_chicago_cohorts.select { |cohort| params[:cohorts].include?(cohort.name) }
    RosterRefresher.new.update_spreadsheet(selected_cohorts) ? (redirect to '/updated') : (redirect to '/')
  end

  redirect to '/'
end
