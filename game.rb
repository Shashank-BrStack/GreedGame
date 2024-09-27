require_relative 'player'
require_relative 'dice_set'

class Game

  attr_accessor :players, :dice_set, :current_player, :final_score, :final_round_score

  def initialize
    @players = []
    @dice_set = DiceSet.new
    @game_over = false
    @final_score = Hash.new
    @final_round_score = 0
  end

  def start
    puts "Enter number of players: "
    num_players = gets.chomp.to_i
    (1..num_players).each do |i|
      puts "Enter name for Player #{i}: "
      player_name = gets.chomp
      @players << Player.new(player_name)
    end
    turn = 1
    until @game_over
      puts "\nTurn #{turn}:"
      puts "--------"
      @players.each do |player|
        play_turn(player)
        if player.total_score >= 3000
          trigger_final_round
        end
        break if @game_over
      end
      turn += 1
    end
    declare_winner
  end

  def play_turn(player)
    puts "#{player.name} rolls:"
    turn_score = 0
    dice_to_roll = 5
    loop do
      dice = @dice_set.roll(dice_to_roll)
      puts "#{dice.join(', ')}"
      score, non_scoring_dice, curr_flag = @dice_set.scoring(dice)
      
      
      if score == 0 && curr_flag == false
        puts "Score in this round: 0"
        puts "#{player.name} loses all points this turn."
        puts " "
        puts "______________________________________________L_O_S_E_C_H_A_N_C_E______________________________________________"
        puts " "
        return
      elsif score == 0 && curr_flag == true
        non_scoring_dice = []
        curr_flag = false
        puts "Running all 5 dices again"
      end
      turn_score += score
      puts "Score in this round: #{score}"
      puts "Total score: #{turn_score}"
      if !player.qualified && turn_score >= 300
        player.qualified = true
        @current_player = player.name
        puts "#{player.name} has qualified with #{turn_score} points!"
        puts " "
        puts "**********************************************************************"
        puts " "
      elsif !player.qualified
        puts "#{player.name} has not yet qualified (needs at least 300 points in one turn)."
        puts " "
        puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        puts " "
        return
      end
      if turn_score >= 3000
        break
      end
      if non_scoring_dice.size == 0
        dice_to_roll = 5
      else
        dice_to_roll = non_scoring_dice.size
      end
      if dice_to_roll > 0 && curr_flag == true
        puts "Do you want to roll the non-scoring #{dice_to_roll} dice? (y/n):"
        answer = gets.chomp.downcase
        break if answer == 'n'
        puts " "
      end
    end
    player.total_score += turn_score
    @final_round_score = player.total_score
    puts "#{player.name}'s total score is now #{player.total_score}."
  end
  
  def trigger_final_round
    puts "#{@current_player} reached 3000 points! Final round begins!"
    puts " "
    puts "**********************************************************"
    puts " "
    @game_over = true
    # Store the player who triggered the final round
    first_player_to_3000 = @players.find { |player| player.name == @current_player }
    # Add the triggering player's score to @final_score right away 
    @final_score[first_player_to_3000.name] = first_player_to_3000.total_score
    # Iterate through all other players to give them one last turn
    @players.each do |player|
      # Skip the player who triggered the final round
      next if player.name == first_player_to_3000.name
      # Display whose turn it is
      puts "#{player.name} gets one last turn."
      puts " "
      puts "**********************************************************"
      puts " "
      play_turn(player)
      # Store the total score after their final turn in @final_score
      @final_score[player.name] = player.total_score
    end
    
  end

  def declare_winner
    winner = @players.max_by(&:total_score)
    puts " "
    puts "_____________________________________W_I_N_N_E_R___________________________________________________"
    puts " "
    puts "#{winner.name} wins with #{winner.total_score} points!"
    puts "_____________________________________W_I_N_N_E_R___________________________________________________"
    puts " "
  end
end

# Start the game
# game = Game.new
# game.start
