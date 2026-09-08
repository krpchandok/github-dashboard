class CreateRepositories < ActiveRecord::Migration[8.1]
  def change
    create_table :repositories do |t|
      t.string :full_name, null: false
      t.string :description
      t.string :html_url
      t.string :language
      t.integer :stargazers_count, default: 0
      t.string :default_branch
      t.string :avatar_url

      t.timestamps
    end

    add_index :repositories, :full_name, unique: true
  end
end