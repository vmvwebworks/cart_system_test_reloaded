RSpec.describe Product do
  it 'creates a product with correct attributes' do
    product = Product.new('GR1', 'Green Tea', [3.11])
    expect(product.code).to eq('GR1')
    expect(product.name).to eq('Green Tea')
    expect(product.prices).to eq([BigDecimal('3.11')])
    expect(product.promotion).to be_nil
  end

  it 'accepts an optional promotion' do
    promo = ->(qty, prices) { prices[0] * qty }
    product = Product.new('CF1', 'Coffee', [11.23], promo)
    expect(product.promotion).to eq(promo)
  end

  it 'raises an error if any price is zero or negative' do
    expect { Product.new('SR1', 'Strawberries', [0]) }.to raise_error(ArgumentError)
    expect { Product.new('SR1', 'Strawberries', [-1]) }.to raise_error(ArgumentError)
  end
end