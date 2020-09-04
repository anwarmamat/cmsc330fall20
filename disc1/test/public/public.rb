require "minitest/autorun"
require_relative "../../src/disc1.rb"

class PublicTests < Minitest::Test
    def setup
        @tuple = Tuple.new(["a", 1, "b", 2]);
        @table = Table.new(["c0", "c1", "c2"]);
    end

    def test_GetSize
        result = @tuple.getSize();
        assert_equal(4, result, "Expected 4, found " + result.to_s());
    end

    def test_GetDataSuccess
        result = @tuple.getData(0);
        assert_equal("a", result , "Expected a, found " + result.to_s());
    end

    def test_GetDataFailure
        result = @tuple.getData(4);
        assert_nil(result, "Expected nil, found " + result.to_s());
    end 

    def test_GetNumTuples 
        t1 = Tuple.new(["a", 1, "c", 2, "d", 4, 5, 7]) 
        t2 = Tuple.new(["b", 2, "c", 4, 9, 8, "e", 7])
        result = Tuple.getNumTuples(8) 
        assert_equal(2, result, "Expected 2 tuples of size 8, got " + result.to_s()) 
        t3 = Tuple.new([])
        result = Tuple.getNumTuples(0)
        assert_equal(1, result, "Expected 1 tuple of size 0, got " + result.to_s) 
    end


    def test_InsertValidTuple
        assert(@table.insertTuple(Tuple.new([1,2,3])), "Expected successful insertion of tuple");
        result = @table.getSize();
        assert_equal(1, result, "Expected table of size 1, found size " + result.to_s());

        @table.insertTuple(Tuple.new([4,5,6]));
        @table.insertTuple(Tuple.new([7,8,9]));
        result = @table.getSize();
        assert_equal(3, result, "Expected table of size 1, found size " + result.to_s());
    end

    def test_InsertInvalidTuple
        assert(!@table.insertTuple(Tuple.new([1,2,3,4])), "Expected failed insertion of tuple");
        result = @table.getSize();
        assert_equal(0, result, "Expected table of size 0, found " + result.to_s());
    end

    def test_SelectTuples
        @table.insertTuple(Tuple.new([1, 2, 3]));
        @table.insertTuple(Tuple.new(["one", "two", "three"]))
        result = @table.selectTuples(["c1", "c2"]); #result should be a new table
        resultTups = result.getTuples()
        assert_equal(2, resultTups.size(), "Expected result of size 2, found " + resultTups.size().to_s());
        assert_equal(2, resultTups[0].getSize(), "Expected tuples of size 2, found tuples of size " + resultTups[0].getSize().to_s());
        data = resultTups[0].getData(0);
        assert_equal(2, data, "Expected 2, found " + data.to_s());
        data = resultTups[1].getData(1);
        assert_equal("three", data, "Expected \"three\", found " + data.to_s());

        @table.insertTuple(Tuple.new(["a", "b", "c"]));
        result = @table.selectTuples(["c2"]);
        resultTups = result.getTuples()
        assert_equal(3, resultTups.size(), "Expected result of size 3, found " + resultTups.size().to_s());
        assert_equal(1, resultTups[0].getSize(), "Expected tuples of size 1, found tuples of size " + resultTups[0].getSize().to_s());
        assert_equal(1, resultTups[2].getSize(), "Expected tuples of size 1, found tuples of size " + resultTups[0].getSize().to_s());

        data = resultTups[2].getData(0);
        assert_equal("c", data, "Expected c, found " + data.to_s());
    end
end
