class Player
  attr_accessor :name, :total_score, :qualified
  def initialize(name)
    @name = name
    @total_score = 0
    @qualified = false
  end
end
