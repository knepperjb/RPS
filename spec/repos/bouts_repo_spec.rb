
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
    result = Rps::BoutsRepo.save(db, {:chal_choice => 'pizza', :match_id => match[:id]})
    expect(result['chal_choice']).to eq('pizza')
    expect(result[:match_id]).to eq(match[:id])
    expect(result['id']).to_not be_nil
    expect(bout_count(db)).to eq(1)
  end
  
  it 'adds contenders choice to bout' do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "username" => "Jamie", "password" => "pass123" })
    match = Rps::MatchRepo.create_match(db, user1['id'], user2['id'])
    bout = Rps::BoutsRepo.save(db, {:chal_choice => 'pizza', :match_id => match[:id]})
    result = Rps::BoutsRepo.save(db, {'cont_choice' => 'cutter', 'id' => bout['id']})
    expect(result['id']).to eq(bout['id'])
    expect(result['cont_choice']).to eq('cutter')
  end

  xit "declares a winner" do
    expect(bout_count(db)).to eq(0)
    result = Rps::BoutsRepo.new(db, {:chal_choice => 'pan', :cont_choice => 'pizza'})
    expect(bout_count(db)).to be(1)
    expect(result['cont_choice']).to eq('pizza')
    Rps::BoutsRepo.winner(db, result['id'], 'dave')
    x = result['id']
    newresult = db.exec("SELECT * from bouts WHERE id = #{x}").first
    expect(newresult['winner']).to eq('dave')
  end

  xit "finds a bout by id" do
    expect(bout_count(db)).to eq(0)
    result = Rps::BoutsRepo.new(db, {:chal_choice => 'cutter', :cont_choice => 'pizza'})
    expect(bout_count(db)).to eq(1)
    newresult = Rps::BoutsRepo.find_by_id(db, result['id'])
    expect(newresult['chal_choice']).to eq('cutter')
    expect(newresult['id']).to_not be_nil
    expect(newresult['cont_choice']).to eq('pizza')
  end

  xit "finds a bout by match id" do
    expect(bout_count(db)).to eq(0)
    result = Rps::BoutsRepo.new(db, {:chal_choice => 'cutter', :cont_choice => 'pizza', :match_id => 9999999})
    expect(bout_count(db)).to eq(1)
    newresult = Rps::BoutsRepo.find_by_match_id(db, result['match_id'])
    expect(newresult['chal_choice']).to eq('cutter')
    expect(newresult['id']).to_not be_nil
    expect(newresult['cont_choice']).to eq('pizza')
  end
    
end


