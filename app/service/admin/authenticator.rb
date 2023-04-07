class Admin::Authenticator
    def initialize(adimnstrator)
      @adimnstrator = adimnstrator
    end
  
    def authenticate(raw_password)
      @adimnstrator &&
      @adimnstrator.hashed_password &&
      # (@adimnstrator.end_date.nil? || @adimnstrator.end_date > Date.today) &&
      BCrypt::Password.new(@adimnstrator.hashed_password) == raw_password
    end
  end