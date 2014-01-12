before '/' do
  redirect to '/authenticate' unless authenticated?
end

get '/' do
  @cohorts = recent_chicago_cohorts
  erb :index
end
