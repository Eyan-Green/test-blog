class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :type_of_notification
      t.boolean :read, default: false
      t.belongs_to :targetable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :actor_id

      t.timestamps
    end
    add_index :notifications, :actor_id
  end
end
