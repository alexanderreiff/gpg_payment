require 'uri'

module GPGPayment
  class Transaction
    include HTTParty
    
    base_uri 'https://www.gpgway.com/gateway'
    ssl_version :SSLv3
    
    def initialize(card, invoice_id = '', trans_description = '')
      @card = card
      @params = @card.to_gpg_params
      @params[:clientinvoiceid] = invoice_id
      @params[:clienttransdescription] = trans_description
      @params[:avs] = 'Y'
      @params.merge! GPGPayment.config
    end
    
    def method_missing(method, *args)
      raise NoMethodError unless [:authorize, :charge, :capture, :void, :refund].include? method
      @params[:transactiontype] = case method
        when :authorize
          'auth'
        when :charge
          'sale'
        else
          method.to_s
      end
      
      case args[0]
        when Numeric
          @params[:amount] = args[0]
        when String
          @params[:anatransactionid] = args[0]
        when Hash
          @params.merge! args[0]
        else
          raise TypeError, 'Transaction value must be a number, string or hash of valid GPG parameters.'
      end
      gpg_call
    end
    
    private
      def gpg_call
        if @card.card_number == '4444444444444444' && ! Rails.env.production?
          Response.new 'responsetext=TEST CARD APPROVAL&approvecode=TEST123456&anatransactionid=TEST123456&response=1&responsecode=00'
        else
          Response.new self.class.post '/GPGCCProcess.aspx', {body: @params}
        end
      end
  end
end