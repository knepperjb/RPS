module Rps
  class Winning
  
#     returns a bout winner if bout is completed 
#     will return nothing if bout is not complete
#       returns tie if the bout results in a tie
    def self.is_bout_complete(db, bout_id)
      data = BoutsRepo.find_by_id(db, bout_id)
      if data['cont_choice']
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
            winner = BoutsRepo.winner(db, bout_data)
            winner['winner']
      end
            
      if challenger_choice == 'pizza' && contender_choice == 'cutter' ||
            challenger_choice == 'pan' && contender_choice == 'pizza' ||
            challenger_choice == 'cutter' && contender_choice == 'pan'
              #contender wins
             bout_data['winner'] = match_data['contender_id']
             winner = BoutsRepo.winner(db, bout_data)
             winner['winner']
      end
    end
    
  #   returns a match winner if match is completed 
#     retunrs nil if match is not complete
    def self.is_match_complete(db, match_id)
      winners = BoutsRepo.winner_count(db, match_id)
      winners.each do |winner|
        if winner['count'] = 3 && winner['winner'] != nil 
          return winner['winner']
        end
      end
    end
      
    
    
  end
  
end