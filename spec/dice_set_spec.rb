require_relative '../dice_set'
RSpec.describe DiceSet do
  let(:dice_set) { DiceSet.new }
  
  it "rolls the correct number of dice" do
    expect(dice_set.roll(5).size).to eq(5)
  end
  
  it "returns an array with numbers between 1 and 6" do
    expect(dice_set.roll(5)).to all(be_between(1, 6))
  end
  
  it "calculates the correct score for a roll of three 1s" do
    dice = [1, 1, 1, 2, 3]
    score, _, _ = dice_set.scoring(dice)
    expect(score).to eq(1000)
  end
  
  it "calculates the correct score for a roll of three 5s" do
    dice = [5, 5, 5, 2, 3]
    score, _, _ = dice_set.scoring(dice)
    expect(score).to eq(500)
  end
  
  it "returns 0 points for non-scoring rolls" do
    dice = [2, 3, 4, 6, 6]
    score, _, _ = dice_set.scoring(dice)
    expect(score).to eq(0)
  end
end