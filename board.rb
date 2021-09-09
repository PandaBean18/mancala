require "byebug"
class Board
    attr_accessor :cups

    def initialize(name1, name2)
        @name1 = name1
        @name2 = name2
        @cups = Array.new(14) {Array.new(4, :stone)}
        @cups[6] = []
        @cups[13] = []

    end
    
    def valid_move?(start_pos)
        if start_pos == 6 || start_pos >= 13
            raise "Invalid starting cup"
            false
        elsif @cups[start_pos].empty? 
            raise "Starting cup is empty"
            false
        end
        true
    end

    def make_move(start_pos, current_player_name)
        idx = nil
        if valid_move?(start_pos)
            num_stones = @cups[start_pos].length
            @cups[start_pos] = []
            unavailable_cup = nil
            if current_player_name == @name1
                unavailable_cup = 13
            else
                unavailable_cup = 6
            end
            i = start_pos + 1
            until num_stones == 0
                idx = i % 14
                if idx == unavailable_cup
                    i += 1
                    next
                end 
                @cups[idx] << :stone
                num_stones -= 1
                i += 1
            end
        end
        render
        next_turn(idx)
    end

    def next_turn(ending_cup_idx)
        if ending_cup_idx == 6 || ending_cup_idx == 13
            return :prompt
        elsif @cups[ending_cup_idx].length == 1 
            return :switch
        else
            return ending_cup_idx
        end

    end

    def render
        print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
        puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
        print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
        puts ""
        puts ""
    end

    def one_side_empty?
        @cups[0...6].all? {|x| x.empty?} || @cups[7...13].all? {|x| x.empty?}
    end

    def winner
        if @cups[6] == @cups[13]
            return :draw
        elsif @cups[6].length > @cups[13].length
            return @name1
        else
            return @name2
        end
    end
end
