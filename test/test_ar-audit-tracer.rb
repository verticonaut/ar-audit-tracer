require 'helper'

class TestArAuditTracer < Test::Unit::TestCase

  def setup
    Concern::Audit::Author.current=nil  
  end

  def test_author_attributes_available
    # test :string coded authors
    assert WithStringAuthor.columns_hash.key? 'created_by'
    assert WithStringAuthor.columns_hash.key? 'updated_by'

    # test :string coded authors
    assert WithIntegerAuthor.columns_hash.key? 'created_by'
    assert WithIntegerAuthor.columns_hash.key? 'updated_by'
  end

  def test_author_attributes_have_correct_type
    # test :string coded authors
    assert_equal(WithStringAuthor.columns_hash['created_by'].type, :string)
    assert_equal(WithStringAuthor.columns_hash['updated_by'].type, :string)

    # test :string coded authors
    assert_equal(WithIntegerAuthor.columns_hash['created_by'].type, :integer)
    assert_equal(WithIntegerAuthor.columns_hash['updated_by'].type, :integer)
  end

  def test_author_setting_on_create
    # test :string coded authors
    Concern::Audit::Author.current="creator"
    audited_record = WithStringAuthor.create!
    
    assert_equal audited_record.created_by, "creator"
    assert_equal audited_record.updated_by, "creator"

    # test :integer coded authors
    Concern::Audit::Author.current= 1
    audited_record = WithIntegerAuthor.create!

    assert_equal audited_record.created_by, 1
    assert_equal audited_record.updated_by, 1
  end

  def test_string_author_setting_on_update
    Concern::Audit::Author.current="creator"
    audited_record = WithStringAuthor.create!

    assert_equal audited_record.created_by, "creator"
    assert_equal audited_record.updated_by, "creator"

    Concern::Audit::Author.current="updater"
    audited_record.update_attribute(:name, "some_name")

    assert_equal audited_record.created_by, "creator"
    assert_equal audited_record.updated_by, "updater"
  end

  def test_integer_author_setting_on_update
    Concern::Audit::Author.current= 1
    audited_record = WithStringAuthor.create!

    assert_equal audited_record.created_by, 1
    assert_equal audited_record.updated_by, 1

    Concern::Audit::Author.current= 2
    audited_record.update_attribute(:name, "some_name")

    assert_equal audited_record.created_by, 1
    assert_equal audited_record.updated_by, 2
  end

  def test_string_author_with_ignored_save
    Concern::Audit::Author.current= "creator"
    audited_record = WithStringAuthor.create!
    assert_equal audited_record.updated_by, "creator"

    Concern::Audit::Author.current= "updater"
    audited_record.save # save is not executed - there is nothing changed
    assert_equal audited_record.updated_by, "creator"
  end

  def test_integer_author_with_ignored_save
    Concern::Audit::Author.current= 1
    audited_record = WithStringAuthor.create!
    assert_equal audited_record.updated_by, 1

    Concern::Audit::Author.current= 2
    audited_record.save # save is not executed - there is nothing changed
    assert_equal audited_record.updated_by, 1
  end

end