module Rps
  class BoutsRepo

    def self.save(db, bout_data)
      if bout_data['cont_choice']
        sql = %q[UPDATE bouts SET cont_choice = $1 WHERE id = $2 RETURNING *]
        result = db.exec(sql, [bout_data['cont_choice'], bout_data['id']])
        result.entries.first
      else 
        sql = %q[INSERT INTO bouts (chal_choice, match_id)  VALUES ($1, $2) RETURNING *]
        result = db.exec(sql, [bout_data['chal_choice'], bout_data['match_id']])
        result.entries.first
      end
    end

    def self.winner(db, bout_data)
      sql = %q[UPDATE bouts SET winner = $2 WHERE id = $1 RETURNING *]
      result = db.exec(sql, [bout_data['id'], bout_data['winner']])
      puts result.entries.first
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
      result.entries
    end
    
    def self.winner_count(db, match_id)
      sql = %q[
      SELECT DISTINCT 
        winner, 
        count(*) 
      FROM bouts 
      WHERE match_id = $1 
      GROUP BY winner
      ]
      db.exec(sql, [match_id]).entries
    end
  end
end