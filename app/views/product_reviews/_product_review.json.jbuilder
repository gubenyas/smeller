json.extract! product_review, :id, :product_id, :content, :created_at, :updated_at
json.url product_review_url(product_review, format: :json)
