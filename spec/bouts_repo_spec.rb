
require 'spec_helper'


describe Rps::BoutsRepo do

  def bout_count(db)
    db.exec("SELECT COUNT(*) from bouts")[0]["count"].to_i
  end

  let(:db) {Rps.create_db_connection('rps_test')}

  before(:each) do
    Rps.clear_db(db)
  end

  it "saves a bout to the database" do
    expect(bout_count(db)).to eq(0)
    result = Rps::BoutsRepo.new(db, {:chal_choice => 'pizza', :cont_choice => 'cutter', :match_id => 4})
    expect(result['chal_choice']).to eq('pizza')
    expect(result['cont_choice']).to eq('cutter')
    expect(result['id']).to_not be_nil
    expect(bout_count(db)).to eq(1)
  end

  it "declares a winner" do
    expect(bout_count(db)).to eq(0)
    result = Rps::BoutsRepo.new(db, {:chal_choice => 'pan', :cont_choice => 'pizza'})
    expect(bout_count(db)).to be(1)
    expect(result['cont_choice']).to eq('pizza')
    Rps::BoutsRepo.winner(db, result['id'], 'dave')
    x = result['id']
    newresult = db.exec("SELECT * from bouts WHERE id = #{x}").first
    expect(newresult['winner']).to eq('dave')
  end

  it "finds a bout by id" do
    expect(bout_count(db)).to eq(0)
    result = Rps::BoutsRepo.new(db, {:chal_choice => 'cutter', :cont_choice => 'pizza'})
    expect(bout_count(db)).to eq(1)
    newresult = Rps::BoutsRepo.find_by_id(db, result['id'])
    expect(newresult['chal_choice']).to eq('cutter')
    expect(newresult['id']).to_not be_nil
    expect(newresult['cont_choice']).to eq('pizza')
  end

  it "finds a bout by match id" do
    expect(bout_count(db)).to eq(0)
    result = Rps::BoutsRepo.new(db, {:chal_choice => 'cutter', :cont_choice => 'pizza', :match_id => '2'})
    expect(bout_count(db)).to eq(1)
    newresult = Rps::BoutsRepo.find_by_match_id(db, result['match_id'])
    expect(newresult['chal_choice']).to eq('cutter')
    expect(newresult['id']).to_not be_nil
    expect(newresult['cont_choice']).to eq('pizza')
  end
    
end


