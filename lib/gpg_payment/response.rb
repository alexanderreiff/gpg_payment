module GPGPayment
  class Response
    attr_reader :response, :response_code, :response_text, :approval_code, :transaction_id
    
    def initialize(raw)
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
  end
end