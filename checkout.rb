# checkout.rb
require 'bigdecimal'

PRICES = {
  'GR1' => [BigDecimal('3.11')],
  'SR1' => [BigDecimal('5.00'), BigDecimal('4.50')],
  'CF1' => [BigDecimal('11.23')]
}

PRICING_RULES = {
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

class Checkout
  def initialize(pricing_rules = PRICING_RULES, prices = PRICES)
    @pricing_rules = pricing_rules
    @prices = prices
    @items = []
  end

  def scan(product_code)
    @items << product_code
  end

  def total
    grouped = @items.tally
    total = BigDecimal('0')
    grouped.each do |code, qty|
      rule = @pricing_rules[code]
      prices = @prices[code]
      raise ArgumentError, "No pricing rule for product code: #{code}" unless rule
      raise ArgumentError, "No price for product code: #{code}" unless prices
      total += rule.call(qty, prices)
    end
    "£#{'%.2f' % total.to_f}"
  end
end

# --- Tests ---

if __FILE__ == $0
  require 'minitest/autorun'

  class CheckoutTest < Minitest::Test
    def setup
      @checkout = Checkout.new
    end

    def test_gr1_offer
      co = Checkout.new
      co.scan('GR1')
      co.scan('GR1')
      assert_equal '£3.11', co.total
    end

    def test_sr1_bulk_discount
      co = Checkout.new
      co.scan('SR1')
      co.scan('SR1')
      co.scan('SR1')
      assert_equal '£13.50', co.total
    end

    def test_cf1_discount
      co = Checkout.new
      co.scan('CF1')
      co.scan('CF1')
      co.scan('CF1')
      assert_equal '£22.46', co.total
    end

    def test_mixed_basket
      co = Checkout.new
      co.scan('GR1')
      co.scan('SR1')
      co.scan('GR1')
      co.scan('GR1')
      co.scan('CF1')
      assert_equal '£22.45', co.total
    end

    def test_invalid_product_code
      co = Checkout.new
      co.scan('INVALID')
      assert_raises(ArgumentError) { co.total }
    end
  end
end