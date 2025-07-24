require_relative '../models/checkout'

RSpec.describe Checkout do
  let(:checkout) { Checkout.new }

  it 'applies the 2-for-1 offer on GR1' do
    checkout.scan('GR1')
    checkout.scan('GR1')
    expect(checkout.total).to eq('£3.11')
  end

  it 'applies the bulk discount on SR1' do
    checkout.scan('SR1')
    checkout.scan('SR1')
    checkout.scan('SR1')
    expect(checkout.total).to eq('£13.50')
  end

  it 'applies the quantity discount on CF1' do
    checkout.scan('CF1')
    checkout.scan('CF1')
    checkout.scan('CF1')
    expect(checkout.total).to eq('£22.46')
  end

  it 'calculates the correct total for a mixed basket' do
    checkout.scan('GR1')
    checkout.scan('SR1')
    checkout.scan('GR1')
    checkout.scan('GR1')
    checkout.scan('CF1')
    expect(checkout.total).to eq('£22.45')
  end

  it 'raises an error if the product code does not exist' do
    expect { checkout.scan('INVALID') }.to raise_error(ArgumentError)
  end
end