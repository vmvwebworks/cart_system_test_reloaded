require 'bigdecimal'

class Product
  attr_reader :code, :name, :prices, :promotion

  def initialize(code, name, prices, promotion = nil)
    @code = code
    @name = name
    @prices = prices.map { |p| BigDecimal(p.to_s) }
    @promotion = promotion
    raise ArgumentError, "Price must be positive" if @prices.any? { |p| p <= 0 }
  end
end