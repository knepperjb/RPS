require 'securerandom'
module Rps
  class ApiKeyRepo
  
  def self.generate_api_key
    SercureRandom.hex
  end
  
  
  end
end