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
    result = Rps::Winning.bout_winner(db, bout['id'])
    expect(result).to eq(user2['id'])
  end
  
end
