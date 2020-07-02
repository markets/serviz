require 'serviz/version'

module Serviz
  class Base
    attr_accessor :errors, :result

    def self.call(*args)
      instance = new(*args)
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
