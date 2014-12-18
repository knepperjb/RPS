require_relative '../lib/rps'

describe Rps::ApiKeyRepo do
  
  def key_count(db)
    db.exec('SELECT COUNT(*) FROM api_keys')
  end
  
  let(:db){ Rps.create_db_connection('rps_test') }
  
  before(:each) do
    Rps.clear_db(db)
  end
  
  it 'generates an api key' do
     api_key = Rps::ApiKeyRepo.generate_api_key
     puts api_key
     expect(api_key).to_not be_nil
  end
  
end

  
  
    