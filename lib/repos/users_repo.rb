
module Rps
  class UsersRepo

    # Results returned in array (for RSpec test purposes)
    def self.all(db)
      db.exec("SELECT * FROM users").to_a
    end

    # Find user's (challenger/contender) USERNAME and PASSWORD by their associated ID
    def self.find(db, user_id)
      db.exec("SELECT username, password FROM users WHERE id = $1", [user_id])[0]
    end

    # If user (challenger/contender) has an associated ID, they can modify their USERNAME & PASSWORD
    # Else, USERNAME and PASSWORD must be entered if (challenger/contender) is signing up for the first time (ID will be generated)
    def self.save(db, user_data)
      if user_data["id"]
        db.exec("UPDATE users SET username = $1, password = $2 WHERE id = $3 RETURNING *", [user_data["username"], user_data["password"], user_data["id"]])[0]    
      else 
        db.exec("INSERT INTO users (username, password) VALUES ($1, $2) RETURNING *", [user_data["username"], user_data["password"]])[0]
      end
    end

    # Delete user (challenger/contender) by their associated ID
    def self.destroy(db, user_id)
        db.exec("DELETE FROM users WHERE id = $1", [user_id])
    end

  end
end
