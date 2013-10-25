require 'gpg_payment/response'
require 'gpg_payment/credit_card'
require 'gpg_payment/transaction'
require 'gpg_payment/railtie' if defined? Rails

module GPGPayment
  def self.config
		@@config ||= {}
	end

	def self.configure
		yield self.config
	end
end