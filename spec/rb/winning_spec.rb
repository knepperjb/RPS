require 'spec_helper'

describe Rps::BoutsRepo do

  def bout_count(db)
    db.exec("SELECT COUNT(*) from bouts")[0]["count"].to_i
  end

  let(:db) {Rps.create_db_connection('rps_test')}

  before(:each) do
    Rps.clear_db(db)
  end

  it "determines winner of a bout" do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout['id']})
    result = Rps::Winning.bout_winner(db, bout['id'])
    expect(result).to eq(user2['id'])
  end
  
  it 'finds if a bout is complete' do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    status = Rps::Winning.is_bout_complete(db, bout['id'])
    expect(status).to be_nil
    Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout['id']})
    result = Rps::Winning.is_bout_complete(db, bout['id'])
    expect(result).to eq(user2['id'])
  end
  
  it 'finds determines the winner of a match' do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout1 = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout1['id']})
    Rps::Winning.is_bout_complete(db, bout1['id'])
    
    bout2 = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout2['id']})
    Rps::Winning.is_bout_complete(db, bout2['id'])
    
    bout3 = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'pizza', 'id' => bout3['id']})
    Rps::Winning.is_bout_complete(db, bout3['id'])
    
    bout4 = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'pizza', 'id' => bout4['id']})
    Rps::Winning.is_bout_complete(db, bout4['id'])
    
    bout5 = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'pizza', 'id' => bout5['id']})
    Rps::Winning.is_bout_complete(db, bout5['id'])
    
    bout6 = Rps::BoutsRepo.save(db, {'chal_choice' => 'pizza', 'match_id' => match['id']})
    Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout6['id']})
    Rps::Winning.is_bout_complete(db, bout6['id'])
    
    result = Rps::Winning.is_match_complete(db, match['id'])
    expect(result).to eq(user2['id'])
  end
  
  
  
end
