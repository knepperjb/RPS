## WIP - RUFINO

#require 'spec_helper'
#require 'pg'


describe Rps::UsersRepo do

  def user_count(db)
    db.exec("SELECT COUNT(*) FROM users")[0]["count"].to_i
  end

  let(:db) { Rps.create_db_connection('rps_test') }

  before(:each) do
    Rps.clear_db(db)
  end

  xit "gets all users" do
    db.exec("INSERT INTO users (name) VALUES ($1)", ["Alice"])
    db.exec("INSERT INTO users (name) VALUES ($1)", ["Bob"])

    users = Library::UserRepo.all(db)
    expect(users).to be_a Array
    expect(users.count).to eq 2

    names = users.map {|u| u['name'] }
    expect(names).to include "Alice", "Bob"
  end

  xit "creates users" do
    expect(user_count(db)).to eq 0

    user = Library::UserRepo.save(db, { 'name' => "Alice" })
    expect(user['id']).to_not be_nil
    expect(user['name']).to eq "Alice"

    # Check for persistence
    expect(user_count(db)).to eq 1

    user = db.exec("SELECT * FROM users")[0]
    expect(user['name']).to eq "Alice"
  end

  xit "finds users" do
    user = Library::UserRepo.save(db, { 'name' => "Alice" })
    retrieved_user = Library::UserRepo.find(db, user['id'])
    expect(retrieved_user['name']).to eq "Alice"
  end

  xit "updates users" do
    user1 = Library::UserRepo.save(db, { 'name' => "Alice" })
    user2 = Library::UserRepo.save(db, { 'id' => user1['id'], 'name' => "Alicia" })
    expect(user2['id']).to eq(user1['id'])
    expect(user2['name']).to eq "Alicia"

    # Check for persistence
    user3 = Library::UserRepo.find(db, user1['id'])
    expect(user3['name']).to eq "Alicia"
  end

  xit "destroys users" do
    user = Library::UserRepo.save(db, { 'name' => "Alice" })
    expect(user_count(db)).to eq 1

    Library::UserRepo.destroy(db, user['id'])
    expect(user_count(db)).to eq 0
  end
end