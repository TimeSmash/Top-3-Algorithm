    def most_marked(quality)
        most_marked_drinks = []
        drink_and_count_arr = []
        Drink.all.each do |drink|
          counter = 0
          drink.user_drinks.each do |user_drink|
              if user_drink[quality] === true
                  counter += 1
              end
          end
          drink_and_count_arr.push({"drink" => drink, "count" => counter})
        end
        three_highest_counts = drink_and_count_arr.map{|obj| obj["count"]}.sort.slice(drink_and_count_arr.length-3,drink_and_count_arr.length-1)
        if three_highest_counts.uniq.length === 1
            most_marked_drinks = drink_and_count_arr.select do |obj| 
                obj["count"] === three_highest_counts.uniq[0]
            end.shuffle().slice(0,3)
        else 
          tier_1_ranked_drinks = drink_and_count_arr.select do |obj|
            obj["count"] === three_highest_counts.last 
          end
          if tier_1_ranked_drinks.length === 2
            most_marked_drinks[0] = tier_1_ranked_drinks[0]
            most_marked_drinks[1] = tier_1_ranked_drinks[1]
            second_place = drink_and_count_arr.select do |ele|
                    ele["count"] === three_highest_counts[0] 
            end.shuffle().first
            most_marked_drinks[2] = second_place
          elsif tier_1_ranked_drinks.length === 1 
                most_marked_drinks[0] = tier_1_ranked_drinks[0]
                if three_highest_counts[0] === three_highest_counts[1] 
                    second_and_third_place = drink_and_count_arr.select{|obj| obj["count"] === three_highest_counts[1]}.shuffle().slice(0,2)
                    most_marked_drinks[1] = second_and_third_place[0]
                    most_marked_drinks[2] = second_and_third_place[1]    
                else 
                    second_place = drink_and_count_arr.select do |obj|
                        obj["count"] === three_highest_counts[1] 
                    end.first
                    most_marked_drinks[1] = second_place
                    third_place = drink_and_count_arr.select do |obj|
                        obj["count"] === three_highest_counts[0] 
                    end.shuffle().first
                    most_marked_drinks[2] = third_place
                end
            end
        end
        return most_marked_drinks
    end
    
