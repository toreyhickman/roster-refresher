get '/cohorts' do
  @cohorts = recent_cohorts
  erb :_cohorts_form, layout: false
end
