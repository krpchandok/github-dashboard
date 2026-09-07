class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :repo_full_name, null: false
      t.string :github_delivery_id, null: false
      t.integer :event_type, null: false
      t.integer :action
      t.string :actor
      t.jsonb :payload
      t.datetime :occurred_at

      t.timestamps
    end

    add_index :events, :github_delivery_id, unique: true
  end
end