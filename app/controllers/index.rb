before '/' do
  redirect to '/authenticate' unless authenticated?
end

get '/' do
  erb :index
end
