class AddAboutToRepositories < ActiveRecord::Migration[8.1]
  def change
    add_column :repositories, :about, :text
  end
end
