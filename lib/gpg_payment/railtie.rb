require 'rails'
require 'yaml'

module GPGPayment
	class Railtie < Rails::Railtie
	  initializer 'gpg_payment.initializer' do
			GPGPayment.configure do |config|
				config.merge! YAML.load_file(Rails.root.join('config', 'gpg_payment.yml'))[Rails.env].symbolize_keys
			end
		end
	end
end