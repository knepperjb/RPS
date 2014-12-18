
require 'spec_helper'


describe Rps::BoutsRepo do

  def bout_count(db)
    db.exec("SELECT COUNT(*) from bouts")[0]["count"].to_i
  end

  let(:db) {Rps.create_db_connection('rps_test')}

  before(:each) do
    Rps.clear_db(db)
  end

  it "saves a new bout to the database" do
    expect(bout_count(db)).to eq(0)
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    result = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    expect(result['chal_choice']).to eq('pizza')
    expect(result['match_id']).to eq(match['id'])
    expect(result['id']).to_not be_nil
    expect(bout_count(db)).to eq(1)
  end
  
  it 'adds contenders choice to bout' do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    result = Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout['id']})
    expect(result['id']).to eq(bout['id'])
    expect(result['cont_choice']).to eq('cutter')
  end

  it "declares a winner" do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout['id']})
    result = Rps::BoutsRepo.winner(db, {'id' => bout['id'], 'winner' => user2['id']})
    expect(result['winner']).to eq(user2['id'])
  end

  it "finds a bout by id" do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    result = Rps::BoutsRepo.find_by_id(db, bout['id'])
    expect(result['chal_choice']).to eq('pizza')
    expect(result['id']).to eq(bout['id'])
    expect(result['match_id']).to eq(match['id'])
  end

  it "finds a bout by match id" do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    result = Rps::BoutsRepo.find_by_match_id(db, match['id'])
    expect(result['id']).to eq(bout['id'])
  end
    
end


