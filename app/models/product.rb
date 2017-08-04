class Product < ActiveRecord::Base
  has_many :reviews, class_name: 'ProductReview'
  # TODO: add unique index for name
end
