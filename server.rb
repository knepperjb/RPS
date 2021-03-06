require 'sinatra'
require 'sinatra/reloader'
require 'bundler/setup'
require 'pry-byebug'
require 'json'
require 'pg'

require_relative 'lib/rps.rb'
require_relative 'lib/repos/api_key_repo.rb'
require_relative 'lib/repos/match_repo.rb'
require_relative 'lib/repos/users_repo.rb'
require_relative 'lib/repos/bouts_repo.rb'


#class Rps::Server < Sinatra::Application

  configure do
      enable :sessions
      set :bind, '0.0.0.0'
  end

  def db
    Rps.create_db_connection('rps_dev')  # Will be rps_dev when we go live  
  end

  # run this before every endpoint to get the current user
  before do
    # this condition assign the current user if someone is logged in
    if params[:apiToken]
      @current_user = Rps::ApiKeyRepo.find_by_api_key(db, params[:apiToken])
    end

    # the next few lines are to allow cross domain requests
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
    headers["Access-Control-Allow-Headers"] = "Origin, X-Requested-With, Content-Type, Accept"
  end


############ MAIN ENDPOINTS ###############

  get '/' do
    send_file 'public/index.html'
  end

  post '/signup' do
    # Acess USERS table
      errors = []
     
      if !params[:password] || params[:password] == ''
        errors << 'blank_password'
      end
     
      if !params[:username] || params[:username] == ''
        errors << 'blank_username'
      end
     
      if Rps::UsersRepo.find_user_by_name(db, params[:username]).length > 0
        errors << 'username_taken'
      end

      if errors.count == 0
        user_data = {username: params[:username], password: params[:password]}
        user = Rps::UsersRepo.save(db, user_data)
#         look into api token instead of id
        session[:user_id] = user['id']
        status 200
        '{}'
      else
        status 400
        { errors: errors }.to_json
      end
    
  end


  post '/signin' do
  # Access USERS table confirm user
  # Access API_KEYS table to insert API Token
  user = Rps::UsersRepo.find_user_by_name(db, params[:username])

    if user && user[0]['password'] == params[:password]
      token = Rps::ApiKeyRepo.add_api_key_to_table(db, user[0]['id'])
      { apiToken: token["api_key"] }.to_json
    else
      status 401
    end

  end

  post '/matches' do
  # Access MATCHES table
  # Create a match between the challenger (challenger_id) and contender (contender_id)
    match = Rps::MatchRepo.create_match(db, challenger_id, contender_id)
  end
  
  get '/matches/:token' do
    user_data = Rps::ApiKeyRepo.find_by_api_key(db, params[:token])
    contenders = Rps::MatchRepo.find_matches_by_player(db, user_data['user_id'])
    contenders.to_json
  end
  
  get '/match/:id' do
    #grabs all the current matches for a user
    JSON.generate(Rps::BoutsRepo.find_by_match_id(db, params[:id]))

  end

  post '/matches/:match_id' do
  # Access BOUTS table
    bout_data = params
    Rps::BoutsRepo.save(db, params)
    complete_bout = Rps::Winning.is_bout_complete(db, params[:bout_id])
    complete_match = Rps::Winning.is_match_complete(db, params[:match_id])
    if complete_bout
      Rps::UsersRepo.find_by_id(db,complete_bout)
      if complete_match
        Rps::UsersRepo.find_by_id(db,complete_match)
      end
    end
  end

  get '/matches/:match_id' do
  # Access BOUTS table to return history of match for challenger_id & contender_id
    bout_history = Rps::BoutsRepo.find_by_match_id(db, params[:match_id])
   JSON.generate(bout_history)
  end

  get '/users' do
    headers['Content-Type'] = 'application/json'
  # Access USERS table to select (drop down box) the contender
    users = Rps::UsersRepo.all(db)  # returns an array of users 
    JSON.generate(users)
  end


  delete '/signout' do
  # Access API_KEYS table to insert API Token
    Rps::ApiKeyRepo.sign_out(db, params[:apiToken])
    status 200
    '{}'
  end

#end


