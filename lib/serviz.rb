require 'serviz/version'

module Serviz
  class Base
    attr_accessor :errors, :result

    def self.call(*args, **kwargs)
      instance = if args.length > 0 && kwargs.length > 0
                   new(*args, **kwargs)
                 elsif kwargs.length > 0
                   new(**kwargs)
                 else
                   new(*args)
                 end
      instance.call

      yield(instance) if block_given?

      instance
    end

    def call
      raise NotImplementedError
    end

    def errors
      @errors ||= []
    end

    def error_messages(separator = ", ")
      errors.join(separator)
    end

    def success?
      !failure?
    end
    alias_method :ok?, :success?

    def failure?
      errors.any?
    end
    alias_method :error?, :failure?
  end
end
