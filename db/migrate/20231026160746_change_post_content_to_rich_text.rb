class ChangePostContentToRichText < ActiveRecord::Migration[7.1]
  def change
    change_column :posts, :content, :rich_text
  end
end
