module Rps
  class Winning
  
#     returns a bout winner if bout is completed 
#     will return nothing if bout is not complete
    def self.is_bout_complete(db, bout_id)
      data = BoutsRepo.find_by_id(db, bout_id)
      if data['cont_id']
        bout_winner(db,bout_id)
      end
    end
  
    def self.bout_winner(db, bout_id)
      bout_data = BoutsRepo.find_by_id(db, bout_id)
      match_data = MatchRepo.find_match(db, bout_data['match_id'])
      challenger_choice = bout_data['chal_choice']
      contender_choice = bout_data['cont_choice']
      
      if challenger_choice == 'pizza' && contender_choice == 'pan' ||
         challenger_choice == 'pan' && contender_choice == 'cutter' ||
         challenger_choice == 'cutter' && contender_choice == 'pizza'
            #challenger wins
            bout_data['winner'] = match_data['challenger_id']
            puts 'challenger wins'
            puts bout_data
            winner = BoutsRepo.winner(db, bout_data)
            winner['winner']
      end
            
      if challenger_choice == 'pizza' && contender_choice == 'cutter' ||
            challenger_choice == 'pan' && contender_choice == 'pizza'
            challenger_choice == 'cutter' && contender_choice == 'pan'
              #contender wins
             bout_data['winner'] = match_data['contender_id']
             winner = BoutsRepo.winner(db, bout_data)
             puts 'conteder wins'
             puts bout_data
             winner['winner']
      end
    end
    
    
    
    
  end
  
end