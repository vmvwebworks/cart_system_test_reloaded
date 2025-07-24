# Cart System Reloaded
A supermarket checkout system.

### Features
- **Product scanning:** Add products to the cart by their code.
- **Flexible promotions:** Easily configure and change pricing rules for each product.
- **Accurate pricing:** Uses `BigDecimal` for all price calculations to avoid errors.
- **Test-driven development:** All business rules are covered by RSpec tests.

## Products and Promotions

| Product code | Name         | Price  | Promotion Description                                  |
|--------------|--------------|--------|--------------------------------------------------------|
| GR1          | Green Tea    | £3.11  | Buy-one-get-one-free (2-for-1)                        |
| SR1          | Strawberries | £5.00  | If you buy 3 or more, price drops to £4.50 each        |
| CF1          | Coffee       | £11.23 | If you buy 3 or more, price drops to 2/3 of original   |

## Installation
1. Clone the repository:
```bash
git clone <YOUR_REPOSITORY_URL>
cd cart_system_test_reloaded
```
2. Install dependencies:
```bash
bundle install
```
## Use

Open a Ruby interpeter (irb), this is how works.

```ruby
require_relative  'models/checkout'
co = Checkout.new
co.scan('GR1')
co.scan('SR1')
co.scan('GR1')
co.scan('GR1')
co.scan('CF1')
puts co.total 
```

## Run Tests

```bash
rspec
```
*Test fits the requirement results.*

- GR1,SR1,GR1,GR1,CF1 → £22.45
- GR1,GR1 → £3.11
- SR1,SR1,GR1,SR1 → £16.61
- GR1,CF1,SR1,CF1,CF1 → £30.57
