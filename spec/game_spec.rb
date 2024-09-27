require_relative '../game'
require_relative '../player'
require_relative '../dice_set'
RSpec.describe Game do
  let(:game) { Game.new }
  before do
    # Mock the input for the number of players and their names
    allow(game).to receive(:gets).and_return('2', 'Alice', 'Bob')
    game.start
    # Reset player states before each test
    game.players.each do |player|
      player.total_score = 0
      player.qualified = false
    end
  end
  describe '#play_turn' do
    before do
      game.players.each do |player|
        player.total_score = 0
        player.qualified = false
      end
    end

    it 'handles losing all points if the player scores 0' do
      # Mock a non-scoring roll
      allow(game.dice_set).to receive(:roll).and_return([2, 3, 4, 6, 6]) # Score of 0
      allow(game.dice_set).to receive(:scoring).and_return([0, [2, 3, 4, 6, 6], false])
      expect { game.play_turn(game.players[0]) }.to output(/loses all points/).to_stdout
      expect(game.players[0].total_score).to eq(0)
    end
    it 'qualifies a player after scoring 300 or more in a turn' do
      # Mock qualifying roll
      allow(game.dice_set).to receive(:roll).and_return([5, 5, 5, 1, 1]) # Score of 500
      allow(game.dice_set).to receive(:scoring).and_return([500, [], true])
      # Mock the player's response to "Do you want to roll again?" to 'n' (stop rolling)
      allow(game).to receive(:gets).and_return('n')
      expect { game.play_turn(game.players[0]) }.to output(/qualified with 500 points/).to_stdout
      expect(game.players[0].qualified).to be true
    end
  end
  describe '#trigger_final_round' do
    it 'triggers the final round when a player reaches 3000 points' do
      # Simulate Alice reaching 3000 points
      game.players[0].total_score = 3000
      allow(game).to receive(:play_turn) # Prevent playing actual turns
      expect { game.trigger_final_round }.to output(/Final round begins!/).to_stdout
    end
    it 'allows other players one last turn during the final round' do
      # Simulate Alice reaching 3000 points
      game.players[0].total_score = 3000
      allow(game).to receive(:play_turn) # Prevent playing actual turns
      # Check that Bob gets one last turn
      expect { game.trigger_final_round }.to output(/gets one last turn/).to_stdout
    end
  end
  describe '#declare_winner' do
    it 'declares the winner with the highest score' do
      # Mock scores for Alice and Bob
      game.players[0].total_score = 3500
      game.players[1].total_score = 3200
      expect { game.declare_winner }.to output(/Alice wins with 3500 points/).to_stdout
    end
  end
end
