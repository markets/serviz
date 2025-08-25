require 'serviz/version'

module Serviz
  class Base
    attr_accessor :errors, :result

    def self.call(...)
      instance = new(...)
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

require 'serviz/workflow'
