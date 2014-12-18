require 'sinatra'

require_relative 'lib/rps.rb'
require_relative 'lib/repos/api_key_repo.rb'
require_relative 'lib/repos/match_repo.rb'
require_relative 'lib/repos/users_repo.rb'
require_relative 'lib/repos/bouts_repo.rb'

set :bind, '0.0.0.0'

  get '/' do
    send_file 'public/index.html'
  end