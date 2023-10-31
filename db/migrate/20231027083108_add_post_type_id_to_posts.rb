class AddPostTypeIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :post_type_id, :integer
    add_index :posts, :post_type_id
  end
end
