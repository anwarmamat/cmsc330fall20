require "minitest/autorun"
require "rack"
require "tempfile"
require "securerandom"
require_relative "../sandbox.rb"
require_relative "../../src/controller.rb"


DUMMY_NAME = "dummy"
DUMMY_FILE_NAME = "dummy.png"
DUMMY = Tempfile.open DUMMY_FILE_NAME
USERS = ["peterBparker", "milesMorales", "gwenStacey", "spiderHam"]
INPUTS = ["thequickbrownfox", "jumpsoverthelazydog"]
TEXT = "we all live in a yellow submarine"
DUSER = "peterBparker"
TUSER = "milesMorales"
NEW_PASS = "somethingnew"

if File.exists? "data.db.original"
    `cat data.db.original > data.db`
end

def default_auth(ctrl)
	user = DUSER
	session = ctrl.authenticate(DUSER, DUSER)
	[user, session]
end

def default_token(ctrl)
	ctrl.assign_token(DUSER)
end

class ControllerWrapper
	def initialize
		@inner = Controller.new
		@inner.db.transaction
	end

	def teardown
		@inner.db.rollback
	end

	def method_missing(m, *args)
		@inner.send(m, *args.map { |x| x.dup })
	end
end

class PublicTests < MiniTest::Test
	def setup
		@ctrl = ControllerWrapper.new
	end

	def teardown
		@ctrl.teardown
		path = "./src/static/avatars/#{DUMMY_FILE_NAME}"
		File.delete path if File.exists? path
	end

	# public tests to ensure you didn't break the website 

	def test_login_works
		USERS.each do |user|
			session = @ctrl.authenticate(user, user)
			assert_equal true, @ctrl.authorize(user, session)
		end
	end
	
	def test_register_works
		assert_equal false, @ctrl.register("a","a",DUMMY,"b","c")
		assert_equal true, @ctrl.register("a","alex",DUMMY,"b","b")
		assert_equal "alex", @ctrl.get_user("a")[:avatar];
        path = "./src/static/avatars/alex"
		File.delete path if File.exists? path
	end

	def test_tokens 
		user, session = default_auth(@ctrl)
		INPUTS.each do |input|
			token = default_token(@ctrl)
			@ctrl.update_prefs(
				user,
				session,
				input,
				token)
			record = @ctrl.get_user(user)
			assert_equal record[:description], input
		end
	end

	def test_search
		INPUTS.each do |input|
			output = @ctrl.search(input)[:query]
			assert_equal output, input
		end
	end
end
