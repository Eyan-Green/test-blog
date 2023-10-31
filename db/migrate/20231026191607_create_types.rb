class CreateTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :types do |t|
      t.string :name
      t.boolean :active, default: true
      t.string :type

      t.timestamps
    end
  end
end
