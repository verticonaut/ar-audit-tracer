class AddAuthors < ActiveRecord::Migration

  def up
    add_authors(:blank_twos, :string, :null => true)
  end

end
