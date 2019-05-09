class Game < ApplicationRecord
  has_many :players
  has_many :rounds

  # Create prompts and assign them to players for rounds
  def create_rounds
    player_prompts = {}
    total_rounds = self.players.length*2
    prompts = Prompt.all.sample(total_rounds)

    # Randomize rounds
    round_numbers = (1..total_rounds).to_a.shuffle

    prompts.each_with_index do |prompt, i|
      round = Round.create!(prompt_id: prompt.id, round_number: round_numbers[i], game_id: self.id)
      i -= self.players.size if i > self.players.size - 1

      player_prompts[self.players[i].id] ||= []
      player_prompts[self.players[i].id] << {prompt: prompt[:question], round_id: round.id}

      if(i+1 == prompts.length/2)
        player_prompts[self.players[0].id] << {prompt: prompt[:question], round_id: round.id}
      else
        player_prompts[self.players[i+1].id] ||= []
        player_prompts[self.players[i+1].id] << {prompt: prompt[:question], round_id: round.id}
      end
    end
    
    return player_prompts
  end

  # Generate random 4-letter code
  def self.generate_room_code
    ('A'..'Z').to_a.sample(4).join
  end

end
