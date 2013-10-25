require 'URI'

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
        when Float
          @params[:amount] = args[0]
        when String
          @params[:anatransactionid] = args[0]
        when Hash
          @params.merge! args[0]
      end
      gpg_call
    end
    
    private
      def gpg_call
        if @card.card_number == '4444444444444444' && ! Rails.env.production?
          return Response.new parse_response 'responsetext=TEST CARD APPROVAL&approvecode=TEST123456&anatransactionid=TEST123456&response=1&responsecode=00'
        else
          Response.new parse_response self.class.post '/GPGCCProcess.aspx', {body: @params}
        end
      end
      
      def parse_response(resp_text)
        resp = URI.decode_www_form resp_text
        Hash[resp]
      end
  end
end