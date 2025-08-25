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

# Test services for Workflow
class Step1 < Serviz::Base
  def initialize(some_flag: nil)
    @some_flag = some_flag
  end

  def call
    if @some_flag
      self.result = "step1_#{@some_flag}"
    else
      self.errors << 'Step1 failed'
    end
  end
end

class Step2 < Serviz::Base
  def initialize(some_flag: nil)
    @some_flag = some_flag
  end

  def call
    if @some_flag
      self.result = "step2_#{@some_flag}"
    else
      self.errors << 'Step2 failed'
    end
  end
end
