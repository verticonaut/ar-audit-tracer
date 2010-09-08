require 'test/unit'
require File.expand_path('../../../test_helper.rb', __FILE__)

# Test Thread.current stuff.
class Concern::Audit::AuthorTest < Test::Unit::TestCase

  def setup
    Concern::Audit::Author.current = nil
  end
  
  def test_author_setting_in_single_thread
    Concern::Audit::Author.current

    assert_nil Concern::Audit::Author.current
    Concern::Audit::Author.current="the_author"

    assert_equal("the_author", Concern::Audit::Author.current)
  end
  
  def test_author_setting_in_different_threads
    Concern::Audit::Author.current="outer_thread"

    assert_equal("outer_thread", Concern::Audit::Author.current)

    t = Thread.fork do
      assert_nil Concern::Audit::Author.current

      Concern::Audit::Author.current="in_thread"

      assert_equal("in_thread", Concern::Audit::Author.current)
    end

    # check if outer thread has still original value
    t.join
    assert_equal("outer_thread", Concern::Audit::Author.current)
  end

end