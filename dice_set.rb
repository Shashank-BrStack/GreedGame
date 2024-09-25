class DiceSet
  attr_reader :dice
  attr_accessor :current_roll_score
  def initialize
    @current_roll_score = 0
  end

  def roll(n)
    @dice = []
    n.times { @dice.push(rand(1..6)) }
    @dice
  end

  def scoring(dice)
    flag = false
    
    count = Hash.new
    
    dice.each { |curr| 
      if count[curr]
        count[curr]+=1
      else
        count[curr]=1
      end
    }
    @current_roll_score = 0
    # Handle scoring for 1s and 5s
    
    count.each { |k,v|
      if k ==  1
        if count[1] >=3
          @current_roll_score+=1000
          count[1] = count[1] - 3
          if count[1] > 0
            @current_roll_score = @current_roll_score + count[1]*100
          end
        else
          @current_roll_score = @current_roll_score + count[1]*100
        count[1] = 0
        end

      elsif k ==  5
        if count[5] >=3
          @current_roll_score+=500
          count[5] = count[5] - 3
          if count[5] > 0
            @current_roll_score = @current_roll_score + count[5]*50
          end
        else
          @current_roll_score = @current_roll_score + count[5]*50
        count[5] = 0
        end
      end

      if count[k] >= 3
        case k
        when 2
          @current_roll_score+=200
          count[2] = count[2] - 3
        when 3 
          @current_roll_score+=300
          count[3] = count[3] - 3
        when 4
          @current_roll_score+=400
          count[4] = count[4] - 3
        when 6 
          @current_roll_score+=600 
          count[6] = count[6] - 3
        end
      end
    }
    
    non_scoring_dice = []
    count.each { |num, cnt| 
      if count[num] == 0
        count.delete(num)
      end
    }
    v_sum = 0
    count.each{ |k,v|
      v.times { non_scoring_dice.push(-1) }
      v_sum+=v
    }
    if count.size > 0 && v_sum < 5
      flag = true
    end
    
    return @current_roll_score, non_scoring_dice, flag
  end
end