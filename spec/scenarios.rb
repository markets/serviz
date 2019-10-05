class RegisterUser < Serviz::Base
  def initialize(user = nil)
    @user = user
  end

  def call
    if @user
      self.result = @user
    else
      self.errors << 'No user!'
    end

    self
  end
end
