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
  end
end

class PositionalAndKeyword < Serviz::Base
  def initialize(positional, keyword:)
    @positional = positional
    @keyword    = keyword
  end

  def call
    self.result = [@positional, @keyword]
  end
end

class NoCall < Serviz::Base
end
