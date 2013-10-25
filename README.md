# gpg_payment

Gem to interface with Global Payment Gateway (GPG)'s Merchant Processing API in a Ruby on Rails application.

## Installation
Add the following to your Gemfile:
```
gem 'gpg_payment', git: 'git://github.com/alexanderreiff/gpg-payment.git'
```
and run `bundle install`

## Configuration
Create a **gpg_payment.yml** file in the config directory and enter your credentials provided by GPG in the following format:
```
production: 
  apiusername: myusername
  apipassword: mypassword
  clientid: 1234
```
## Example Usage
```
card = GPGPayment::CreditCard.new(
  name: 'Cardholder Name',
  card_number: 4111111111111111,
  exp_month: 10,
  exp_year: 2016,
  billing_zip: 12345
)
trans = GPGPayment::Transaction.new(card, 'InvoiceID', 'Invoice Desc')
auth = trans.authorize 1
puts 'Approved!' if auth.approved?
```