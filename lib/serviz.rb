class Serviz
  attr_accessor :errors, :result

  def self.call(*args)
    new(*args).call
  end

  def call
    raise NotImplementedError
  end

  def errors
    @errors ||= []
  end

  def success?
    !failure?
  end

  def failure?
    errors.any?
  end
end
