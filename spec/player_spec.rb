require_relative '../player'
RSpec.describe Player do
  let(:player) { Player.new("John") }
  
  it "initializes with a name" do
    expect(player.name).to eq("John")
  end
  
  it "initializes with a total score of 0" do
    expect(player.total_score).to eq(0)
  end
  
  it "is not qualified initially" do
    expect(player.qualified).to eq(false)
  end
  
  it "remains unqualified for scores below 300" do
    player.total_score = 299
    player.qualified = false
    expect(player.qualified).to eq(false)
  end
end