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

class AlwaysFailStep < Serviz::Base
  def call
    self.errors << 'Always fails'
  end
end

# Example workflow from the issue description
class SampleWorkflow < Serviz::Workflow
  def initialize(arg1, arg2)
    super()
    @arg1 = arg1
    @arg2 = arg2
  end

  def call
    run Step1, params: { some_flag: @arg1 }
    run Step2, params: { some_flag: @arg2 }, if: ->(result) { result.success? }
  end
end
