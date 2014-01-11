enable :sessions

use OmniAuth::Builder do
  provider :dbc, ENV['OAUTH_CLIENT_ID'], ENV['OAUTH_CLIENT_SECRET']
end

get '/authenticate' do
  redirect to '/auth/dbc'
end

get '/auth/dbc/callback' do
  user_attributes = request.env['omniauth.auth'].info
  session[:user_attributes] = user_attributes
  token = request.env['omniauth.auth'].credentials
  session[:oauth_token] = token_as_hash(token)
  redirect to '/'
end

get '/logout' do
  session.delete(:oauth_token)
  redirect to '/'
end
