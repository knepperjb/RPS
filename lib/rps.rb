require 'pg'
require 'securerandom'

require_relative "repos/api_key_repo.rb"
require_relative "repos/match_repo.rb"
require_relative "repos/users_repo.rb"
require_relative "repos/bouts_repo.rb"

module Rps

  def self.create_db_connection(dbname)
    PG.connect(host: 'localhost', dbname: dbname)
  end

  def self.clear_db(db)
    db.exec %q[
      DELETE FROM users;
      DELETE FROM api_keys;
      DELETE FROM matches;
      DELETE FROM bouts;
    ]
  end

  def self.create_tables(db)
    db.exec %q[
      CREATE TABLE IF NOT EXISTS users (
        id          SERIAL PRIMARY KEY,
        username    VARCHAR UNIQUE,
        password    VARCHAR
        );
      CREATE TABLE IF NOT EXISTS api_keys (
        id          SERIAL PRIMARY KEY,
        api_key     VARCHAR UNIQUE,
        user_id     INTEGER REFERENCES users(id) ON DELETE CASCADE
        );
      CREATE TABLE IF NOT EXISTS matches (
        id              SERIAL PRIMARY KEY,
        challenger_id   INTEGER REFERENCES users(id) ON DELETE CASCADE,
        contender_id    INTEGER REFERENCES users(id) ON DELETE CASCADE,
        winner          INTEGER REFERENCES users(id) ON DELETE CASCADE
        );
      CREATE TABLE IF NOT EXISTS bouts (
        id              INTEGER SERIAL PRIMARY KEY,
        chal_choice     VARCHAR,
        cont_choice     VARCHAR,
        winner          VARCHAR,
        match_id         INTEGER
        );
      ]
  end

  def self.seed_db(db)
    sql = %q[
      INSERT INTO users (username, password) values ($1, $2)
    ]
    db.exec(sql, ['marco polo', 'mongolia'])
    db.exec(sql, ['santa claus', 'hohoho'])
    db.exec(sql, ['brian', 'orphan'])
  end

  def self.drop_tables(db)
    db.exec %q[
      DROP TABLE users CASCADE;
      DROP TABLE matches CASCADE;
      DROP TABLE bouts CASCADE;
      DROP TABLE api_keys CASCADE;
    ]
  end
end
  
        
