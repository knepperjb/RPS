module Rps
  class ApiKeyRepo
  
  def self.generate_api_key
    SecureRandom.hex
  end
  
  def self.add_api_key_to_table(db, user_id)
    sql = %q[
      INSERT INTO api_keys (user_id, api_key)
      VALUES ($1,$2)
      RETURNING *
    ]
    api_key = generate_api_key
    result = db.exec(sql, [user_id, api_key])
    result.entries.first
  end
  
  end
end