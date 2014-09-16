get '/cohorts' do
  @cohorts = recent_chicago_cohorts
  erb :_cohorts_form, layout: false
end
