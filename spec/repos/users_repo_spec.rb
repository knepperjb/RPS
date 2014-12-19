require 'spec_helper'


describe Rps::UsersRepo do

  def user_count(db)
    db.exec("SELECT COUNT(*) FROM users")[0]["count"].to_i
  end

  let(:db) { Rps.create_db_connection('rps_test') }

  before(:each) do
    Rps.clear_db(db)
  end

  it "gets all users" do
    db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Alice", "pass123"])
    db.exec("INSERT INTO users (username, password) VALUES ($1, $2)", ["Bob", "pass456"])

    users = Rps::UsersRepo.all(db)
    expect(users).to be_a Array
    expect(users.count).to eq 2

    names = users.map {|u| u["username"] }
    expect(names).to include "Alice", "Bob"

    passwords = users.map {|u| u["password"] }
    expect(passwords).to include "pass123", "pass456"
  end

  it "creates users" do
    expect(user_count(db)).to eq 0

    user = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    expect(user["id"]).to_not be_nil
    expect(user["username"]).to eq "Alice"
    expect(user["password"]).to eq "pass123"

    # Check for persistence
    expect(user_count(db)).to eq 1

    user = db.exec("SELECT * FROM users")[0]
    expect(user["username"]).to eq "Alice"
    expect(user["password"]).to eq "pass123"
  end

  it "finds users" do
    user = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    retrieved_user = Rps::UsersRepo.find_user_by_id(db, user["id"])
    expect(retrieved_user["username"]).to eq "Alice"
    #expect(retrieved_user["password"]).to eq "pass123"
  end

  it "updates users" do
    user1 = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    user2 = Rps::UsersRepo.save(db, { "id" => user1["id"], "username" => "Charles" , "password" => "pass987" })
    expect(user2["id"]).to eq(user1["id"])
    expect(user2["username"]).to eq "Charles"
    expect(user2["password"]).to eq "pass987"

    # Check for persistence
    user3 = Rps::UsersRepo.find_user_by_id(db, user1["id"])
    expect(user3["username"]).to eq "Charles"
    #expect(user3["password"]).to eq "pass987"
  end

  it "destroys users" do
    user = Rps::UsersRepo.save(db, { "username" => "Alice", "password" => "pass123" })
    expect(user_count(db)).to eq 1

    Rps::UsersRepo.destroy(db, user["id"])
    expect(user_count(db)).to eq 0
  end
end