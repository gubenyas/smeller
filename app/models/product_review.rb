class ProductReview < ActiveRecord::Base
  # TODO: add index for content
  belongs_to :product
end
