require 'serviz/version'
require 'byebug'

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

      instance
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
end
