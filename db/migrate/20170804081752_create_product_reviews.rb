class CreateProductReviews < ActiveRecord::Migration
  def change
    create_table :product_reviews do |t|
      t.integer :product_id
      t.text :content

      t.timestamps null: false
    end
  end
end
