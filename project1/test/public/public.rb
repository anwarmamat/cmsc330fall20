require "minitest/autorun"
require_relative "../../src/wordnet.rb"

$VALID_SYNSETS = "inputs/public_synsets_valid"
$INVALID_SYNSETS = "inputs/public_synsets_invalid"
$VALID_HYPERNYMS = "inputs/public_hypernyms_valid"
$INVALID_HYPERNYMS = "inputs/public_hypernyms_invalid"

class PublicTests < MiniTest::Test
    def setup
        @synsets = Synsets.new
        @hypernyms = Hypernyms.new
    end

    def test_public_synsets_add
        assert_equal(true, @synsets.addSet(0, ["a"]))
        assert_equal(true, @synsets.addSet(1, ["a", "b", "c"]))
        assert_equal(false, @synsets.addSet(-1, ["invalid"]))
    end

    def test_public_synsets_load_valid
        assert_nil(@synsets.load($VALID_SYNSETS))
    end

    def test_public_synsets_load_invalid
        assert_equal([2, 6, 7], @synsets.load($INVALID_SYNSETS)) 
    end

    def test_public_synsets_lookup
        @synsets.load($VALID_SYNSETS)
        assert_equal(["a"], @synsets.lookup(0))
        assert_equal( ["d", "e"], @synsets.lookup(3).sort)
    end

    def test_public_synsets_find
        @synsets.load($VALID_SYNSETS)
        assert_equal([0], @synsets.findSynsets("a"))
        assert_equal({"b" => [1], "e" => [3]}, @synsets.findSynsets(["b", "e"]))
    end

    def test_public_hypernyms_add
        assert_equal(true, @hypernyms.addHypernym(0, 1))
        assert_equal(true, @hypernyms.addHypernym(0, 2))
        assert_equal(true, @hypernyms.addHypernym(0, 1))
    end

    def test_public_hypernyms_load_valid
        assert_nil(@hypernyms.load($VALID_HYPERNYMS))
    end

    def test_public_hypernyms_load_invalid
        assert_equal([1, 4, 7], @hypernyms.load($INVALID_HYPERNYMS))
    end

    def test_public_hypernyms_lca
        @hypernyms.load($VALID_HYPERNYMS)
        assert_equal([3], @hypernyms.lca(0, 1))
        assert_equal([5], @hypernyms.lca(3, 4))
    end

    def test_public_hypernyms_lca_nonode
        @hypernyms.load($VALID_HYPERNYMS)
        assert_nil(@hypernyms.lca(2, 10))
    end

    def test_public_commandline
        parser = CommandParser.new
        assert_equal({:recognized_command => :load, :result => true},
                     parser.parse("load #{$VALID_SYNSETS} #{$VALID_HYPERNYMS}"))
        assert_equal({:recognized_command => :invalid},
                     parser.parse("invalid command"))
        assert_equal({:recognized_command => :lookup, :result => ["a"]},
                     parser.parse("lookup 0"))
    end
end
