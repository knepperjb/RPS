require 'securerandom'
module Rps
  class ApiKeyRepo
  
  def self.generate_api_key
    SecureRandom.hex
  end
  
  
  end
end