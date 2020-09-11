require "minitest/autorun" 
require_relative "../../src/disc2.rb" 

class PublicTests < Minitest::Test 
    def setup
        @hash = {1=>3, 2=>4, 5=>5, 6=>7, 8=>8, 9=>10}
        @arr = [1,2,3,4]
        @arr2 = [1,2,3,4]
        @grader = Grader.new("test/public/names.txt")
    end

    def test_evens
        # "4810" 
        result = evens_string(@hash) 
        assert_equal("4810", result, "Expected \"4810\" but got #{result}")
    end 

    def test_mapWithCodeBlock
        result = map_w_code_block(@arr) {|x| x*2} 
        assert_equal([2, 4, 6, 8], result, "Expected [2,4,6,8], got #{result}") 
        result = map_w_code_block(@arr2)  
        assert_equal([2,3,4,5], result, "")

    end 

    def test_time_teller
        str = "12:31:59 P.M." 
        result = time_teller(str) 
        assert_equal("It is 12 P.M.", result, "Expected \"It is 12 P.M.\" but got #{result}")
        str2 = "15:16:97" 
        result = time_teller(str2) 
        assert_equal("Invalid", result, "Expected \"Invalid\" but got #{result}")
        
    end 

    def test_Grader
        result = @grader.get_grades_for_student("Shilpa Roy") 
        assert_equal(98, result, "") 
        result = @grader.get_grades_for_student("Alex Eng") 
        assert_nil(result, "") 
        @grader.add_extra_credit() {|x| x/2 + 2}
        result = @grader.get_grades_for_student("Shilpa Roy") 
        assert_equal(51, result, "Expected 51 but got #{result}") 
        result = @grader.get_grades_for_student("Alex Eng") 
        assert_nil(result, "") 
    end
end
