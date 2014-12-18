require 'spec_helper'

describe Rps::ApiKeyRepo do
  
  def key_count(db)
    db.exec('SELECT COUNT(*) FROM api_keys').entries.count
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
  
  it 'adds an api key to the api_keys table' do
    user = Rps::UsersRepo.save(db, { "username" => "Jamal", "password" => "pass123" })
    key = Rps::ApiKeyRepo.add_api_key_to_table(db, user['id'])
    expect(key['user_id']).to eq(user['id'])
    expect(key_count(db)).to eq(1)
    expect(key['id']).to_not be_nil
    expect(key['api_key']).to_not be_nil
  end
  

end

  
  
    