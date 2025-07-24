require 'bigdecimal'
require_relative './product'

PROMOTIONS = {
  'GR1' => ->(qty, prices) {
    price = prices[0]
    (qty / 2 + qty % 2) * price
  },
  'SR1' => ->(qty, prices) {
    normal_price, bulk_price = prices
    unit_price = qty >= 3 ? bulk_price : normal_price
    unit_price * qty
  },
  'CF1' => ->(qty, prices) {
    price = prices[0]
    price = price * 2 / 3 if qty >= 3
    price * qty
  }
}

PRODUCTS = {
  'GR1' => Product.new('GR1', 'Green Tea', [BigDecimal('3.11')], PROMOTIONS['GR1']),
  'SR1' => Product.new('SR1', 'Strawberries', [BigDecimal('5.00'), BigDecimal('4.50')], PROMOTIONS['SR1']),
  'CF1' => Product.new('CF1', 'Coffee', [BigDecimal('11.23')], PROMOTIONS['CF1'])
}

class Checkout
  def initialize(products = PRODUCTS)
    @products = products
    @items = []
  end

  def scan(product_code)
    product = @products[product_code]
    raise ArgumentError, "Unknown product code: #{product_code}" unless product
    @items << product
  end

  def total
    grouped = @items.group_by(&:code)
    total = BigDecimal('0')
    grouped.each do |code, products|
      product = products.first
      qty = products.size
      prices = product.prices
      if product.promotion
        total += product.promotion.call(qty, prices)
      else
        total += prices[0] * qty
      end
    end
    "£#{'%.2f' % total.to_f}"
  end
end