module GPGPayment
  class Response
    attr_reader :response, :response_code, :response_text, :approval_code, :transaction_id
    
    def initialize(raw)
      raw = parse_response raw
      @response = raw['response'].to_i
      @approved = @response == 1
      @response_code = raw['responsecode'].to_i
      @response_text = raw['responsetext']
      if @approved
        @approval_code = raw['approvecode']
        @transaction_id = raw['anatransactionid']
      end
    end
    
    def approved?
      @approved
    end

    private
      def parse_response(resp_text)
        resp_text.gsub! ' ', '+'
        resp_text.gsub! '=&', '=+&'
        resp = URI.decode_www_form resp_text
        Hash[resp]
      end
  end
end