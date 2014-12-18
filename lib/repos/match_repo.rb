module Rps
  class MatchRepo

    def self.create_match(db, challenger_id, contender_id)
      sql = %q[INSERT INTO matches (challenger_id, contender_id) VALUES ($1, $2) RETURNING *;]
      result = db.exec(sql, [challenger_id, contender_id])
      result.entries.first
    end

    def self.all_matches(db)
      sql = %q[SELECT * FROM matches;]
      result = db.exec(sql)
      result.entries
    end

    def self.find_match(db, match_id)
      sql = %q[SELECT * FROM matches WHERE id = $1;]
      result = db.exec(sql, [match_id])
      result.entries.first
    end

    def self.find_matches_by_player(db, player_id)
      sql = %q[SELECT * FROM matches WHERE challenger_id = $1 or contender_id = $1;]
      result = db.exec(sql, [player_id])
      result.entries
    end

    def self.save_winner(db, match_id, winner_id)
      sql = %q[UPDATE matches SET winner = $1 WHERE id = $2 RETURNING *;]
      result = db.exec(sql, [winner_id, match_id])
      result.entries.first
    end

  end
end