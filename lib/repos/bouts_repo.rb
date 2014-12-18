module Rps
  class BoutsRepo

    def self.new(db, bout_data)
      sql = %q[INSERT INTO bouts (chal_choice, cont_choice, match_id)  VALUES ($1, $2, $3) returning *]
      result = db.exec(sql, [bout_data[:chal_choice], bout_data[:cont_choice], bout_data[:match_id]])
      result.entries.first
    end

    def self.winner(db, bout_id, winner)
      sql = %q[UPDATE bouts SET winner = $2 WHERE id = $1 RETURNING *]
      result = db.exec(sql, [bout_id, winner])
      result.entries.first
    end

    def self.find_by_id(db, bout_id)
      sql = %q[SELECT * FROM bouts WHERE id = $1]
      result = db.exec(sql, [bout_id])
      result.entries.first
    end

    def self.find_by_match_id(db, match_id)
      sql = %q[SELECT * FROM bouts WHERE match_id = $1]
      result = db.exec(sql, [match_id])
      result.entries.first
    end
  end
end