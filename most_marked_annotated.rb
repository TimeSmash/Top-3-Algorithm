def most_marked(quality)
    most_marked_drinks = []
    drink_and_count_arr = [] #[drink=>drink_obj, count=>FMI count number]
    Drink.all.each do |drink|
        counter = 0
        drink.user_drinks.each do |user_drink|
            if user_drink[quality] === true
                counter += 1
            end
        end
        # puts drink.name + " was " + quality + " " + counter.to_s + " times" 
        drink_and_count_arr.push({"drink" => drink, "count" => counter})
        
    end
    
    three_highest_counts = drink_and_count_arr.map{|obj| obj["count"]}.sort.slice(drink_and_count_arr.length-3,drink_and_count_arr.length-1)
    # If the three highest counts are the same, three or more drinks tied for first
    if three_highest_counts.uniq.length === 1
        # So, set most_marked_drinks to the drinks with this count, then randomize and take 3
        most_marked_drinks = drink_and_count_arr.select do |obj| 
            obj["count"] === three_highest_counts.uniq[0]
        end.shuffle().slice(0,3)
    else 
        # Only one or two drinks have first place
        tier_1_ranked_drinks = drink_and_count_arr.select do |obj|
        obj["count"] === three_highest_counts.last 
        end
        # Use byebug below to see tier_1_ranked_drinks
        # byebug
        if tier_1_ranked_drinks.length === 2
        # 2 drinks tied for first place, set 1st and second place (no need to shuffle, both have same count)
        most_marked_drinks[0] = tier_1_ranked_drinks[0]
        most_marked_drinks[1] = tier_1_ranked_drinks[1]
        #In case 2+ drinks tied for second place, pick random one for index-2 of most_marked
        second_place = drink_and_count_arr.select do |ele|
                ele["count"] === three_highest_counts[0] 
        end.shuffle().first
        most_marked_drinks[2] = second_place
        elsif tier_1_ranked_drinks.length === 1 
            # There is an official first place, only 1 drink has first place, so set it
            most_marked_drinks[0] = tier_1_ranked_drinks[0]
            # Check for ties in second place
            if three_highest_counts[0] === three_highest_counts[1] 
                # 2+ drinks tied for second place, pick random ones for index-1 and index-2 of most_marked
                second_and_third_place = drink_and_count_arr.select{|obj| obj["count"] === three_highest_counts[1]}.shuffle().slice(0,2)
                most_marked_drinks[1] = second_and_third_place[0]
                most_marked_drinks[2] = second_and_third_place[1]    
            else 
                # 2nd and 3rd place are different
                second_place = drink_and_count_arr.select do |obj|
                    obj["count"] === three_highest_counts[1] 
                end.first
                most_marked_drinks[1] = second_place
                #In case 2+ drinks tied for third place, pick random one for index-2 of most_marked
                third_place = drink_and_count_arr.select do |obj|
                    obj["count"] === three_highest_counts[0] 
                end.shuffle().first
                most_marked_drinks[2] = third_place
            end
        end
    end
    return most_marked_drinks
end