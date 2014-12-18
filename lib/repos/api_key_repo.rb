module Rps
  class ApiKeyRepo
  
  def self.generate_api_key
    SecureRandom.hex
  end
  
  def self.add_api_key_to_table(db, user_id)
    api_key = generate_api_key
    
    sql = %q[
      INSERT INTO api_keys (user_id, api_key)
      VALUES ($1,$2)
      RETURNING *
    ]
    result = db.exec(sql, [user_id, api_key])
    result.entries.first
  end
  
  def self.find_key_by_user_id(db, user_id)
    sql = %q[
      SELECT api_key
      FROM api_keys
      WHERE user_id = $1
    ]
    db.exec(sql, [user_id]).entries.first
  end

  def self.find_by_api_key(db, api_key)
    sql = %q[
      SELECT user_id
      FROM api_keys
      WHERE api_key = $1
    ]
    db.exec(sql, [api_key]).entries.first
  end

  def self.sign_out(db, user_id)
      sql = %q[
        DELETE FROM api_keys
        WHERE user_id = $1
        ]

      result = db.exec(sql, [user_id])
      result.entries.first
    end
  
  end
end