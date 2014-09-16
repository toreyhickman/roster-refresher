before '/' do
  redirect to '/authenticate' unless authenticated?
end

get '/' do
  erb :index
end

get '/updated' do
  erb :updated
end

post '/update_spreadsheet' do
  if params[:cohorts]
    selected_cohorts = recent_chicago_cohorts.select { |cohort| params[:cohorts].include?(cohort.name) }
    @update = RosterRefresher.new.update_spreadsheet(selected_cohorts)
  end

  if request.xhr?
    content_type :json

    if @update
      {status: "success"}.to_json
    else
      status 500
      halt(500, {status: "failure"}.to_json)
    end

  else
    @update ? (redirect to '/updated') : (redirect to '/')
  end
end

