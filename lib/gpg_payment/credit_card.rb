module GPGPayment
  class CreditCard
    attr_accessor :name, :card_number, :cvv, :exp_month, :exp_year, :billing_address, :billing_state, :billing_zip, :billing_country
    
    def initialize(**options)
      options.each do |key, value|
        method = (key.to_s + "=").to_sym
        send method, value if respond_to? method
      end
    end
    
    def card_type
    	case card_number[0].to_i
    		when 4
    			'VISA'
    		when 5
    			'MC'
    		when 3
    			'AMEX'
    		when 6
    			'DISC'
    	end
    end
    
    def to_gpg_params
      fields = {name: nil, 
        card_number: :CCNumber, 
        cvv: :CVV,
        exp_year: nil,
        exp_month: nil, 
        billing_address: :CCBillingAddress,
        billing_state: :CCBillingState,
        billing_zip: :CCBillingZip,
        billing_country: :CCBillingCountry
      }
      params = {}
      date = []
      
      fields.each do |attr, param_key|
        case attr
          when :name
            name_parts = self.name.split(' ').map { |part| part.gsub(/[^0-9a-z ]/i, '') }.keep_if { |part| not part.empty? }
            params[:CCHolderFirstName] = name_parts.shift
            params[:CCHolderLastName] = name_parts.join ' '
          when :exp_month
            date[0] = (send attr).to_s.rjust(2, '0')
          when :exp_year
            date[1] = (send attr).to_s.slice(-2, 2)
          else
            value = send attr
            params[param_key] = value if value
        end
      end
      params[:CCExp] = date.join unless date.empty?
      params
    end
  end
end