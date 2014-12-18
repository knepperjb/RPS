# require_relative '../lib/repos/match_repo.rb'

describe Rps::MatchRepo do 
  
  let(:db) { Rps.create_db_connection('library_test') }

  before(:each) do
    Rps.drop_tables(db)
    Rps.create_tables(db)
  end

  it "returns all matches" do
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [1, 2])
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [5, 6])

    matches = Rps::MatchRepo.all_matches(db)
    expect(matches).to be_a Array
    expect(matches.count).to eq 2

    contender_ids = matches.map {|match| match['contender_id'] }
    expect(contender_ids).to include 2, 6
  end

  it "returns a specific match by id" do
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [1, 2])
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [5, 6])
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [7, 8])

    match_info = {:id => 3, :challenger_id => "x", :contender_id => "y"}

    match = Rps::MatchRepo.find_match(db, match_info[:id])
    expect(match).to be_a Hash
    expect(match['challenger_id']).to eq 7 #might be wrong; depends on what happens to the serial primary key ID's when tables are cleared
  end

  it "returns all matches played by a specific player"
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [1, 2])
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [5, 6])
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [7, 1])

    player_info = {:id => 1}

    matches = Rps::MatchRepo.find_matches_by_player(db, player_info[:id])

    expect(matches).to be_a Array
    expect(matches.count).to eq 2
    expect(matches[2]['challenger_id']).to eq 7
  end

  it "updates a match with a winner" do
    db.exec("INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2)", [1, 2])

    match_info = {:id => 3, :challenger_id => "x", :contender_id => "y", :winner_id => 2}

    match = Rps.MatchRepo.save_winner(db, match_info[:id], match_info[:winner_id]) #implies that :winner_id will be added to the match_info hash
    expect(match['id']).to_not be_nil
  end
end

