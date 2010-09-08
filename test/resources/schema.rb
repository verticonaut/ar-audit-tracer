# ------------------------------------------------------
# Defined the migrations
# ------------------------------------------------------
ActiveRecord::Schema.define(:version => 0) do

  create_table :with_string_authors, :force => true do |t|
    t.string :name
    t.authors
  end

  create_table :with_integer_authors, :force => true do |t|
    t.string :name
    t.authors(:integer)
  end
  
end
