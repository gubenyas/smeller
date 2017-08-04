require 'net/http'
class ProductParser
  WALMART_API_URL = 'http://api.walmartlabs.com/v1/'

  def self.parse_new(url)
    new.parse_new(url)
  end

  # TODO: add some exception handling
  def parse_new(url)
    product = nil
    if (m = /\/(?<id>\d+)\?/.match(url))
      product_id = m['id']
      name, price = get_product_details(product_id)
      # TODO: add validation that product with such name is unique
      p = Product.new(name: name, price: price)
      # TODO: only new reviews should be here, they could be compared by content
      p.reviews = get_product_reviews(product_id)
      byebug
      product = p
    end
  end

  def get_product_details(product_id)
    # TODO: extract url preparation and request sending and response parsing to a method
    uri = URI(WALMART_API_URL)
    uri += "items/#{product_id}"
    params = { apiKey: api_key, format: 'json'}
    uri.query = URI.encode_www_form(params)

    resp = Net::HTTP.get_response uri
    result = JSON(resp.body)
    # TODO: condider saving product_id as well -- it could be easier to validate reviews with that
    [result['name'], result['salePrice']]
  end

  # TODO: as it turns out only 5 reviews could be received via API(https://developer.walmartlabs.com/forum/read/185226)
  #   Looks like parsing and paginating HTML on Customer Reviews page(e.g. https://www.walmart.com/reviews/product/54594376) 
  # is the only one way to go though such solution definitely doesn't look as a reliable & efficient
  def get_product_reviews(product_id)
    byebug
    uri = URI(WALMART_API_URL)
    uri += "reviews/#{product_id}"
    params = { apiKey: api_key, format: 'json'}
    uri.query = URI.encode_www_form(params)

    resp = Net::HTTP.get_response uri
    result = JSON(resp.body)
    # TODO: check if Product already exists(was fetched before), response has product name
    reviews = result['reviews'].map do |review|
      # TODO: it makes sense to get more data i.e. reviewer, title, upVotes etc.
      # TODO: skip adding review if such review already exist for a Product i.e. review was fetched before
      ProductReview.new(content: review['reviewText'])
    end
  end

  private
  def api_key
    # TODO: move it to some yml file
    '***'
  end
end