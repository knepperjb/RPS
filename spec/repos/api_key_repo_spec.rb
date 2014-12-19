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
  
  it 'selects an api key by user id' do
    user = Rps::UsersRepo.save(db, { "username" => "Jamal", "password" => "pass123" })
    key = Rps::ApiKeyRepo.add_api_key_to_table(db, user['id'])
    result = Rps::ApiKeyRepo.find_key_by_user_id(db, user['id'])
    expect(result['api_key']).to eq(key['api_key'])
  end

  it 'selects a user id by api key' do
    user = Rps::UsersRepo.save(db, { "username" => "Jamal", "password" => "pass123" })
    key = Rps::ApiKeyRepo.add_api_key_to_table(db, user['id'])
    result = Rps::ApiKeyRepo.find_by_api_key(db, key['api_key'])
    expect(result['user_id']).to eq(key['user_id'])
  end

   it 'deletes user and the associated api_key' do
    user = Rps::UsersRepo.save(db, { "username" => "Jamal", "password" => "pass123" })
    key = Rps::ApiKeyRepo.add_api_key_to_table(db, user['id'])
    delete = Rps::ApiKeyRepo.sign_out(db, key["user_id"])
    result = Rps::ApiKeyRepo.find_key_by_user_id(db, user['id'])
    expect(result).to be_nil
  end

  
end

  
  
    