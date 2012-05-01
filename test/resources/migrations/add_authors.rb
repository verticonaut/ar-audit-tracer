class AddAuthors < ActiveRecord::Migration

  def self.up
    add_authors(:blank_twos, :string, :null => true)
  end

end
