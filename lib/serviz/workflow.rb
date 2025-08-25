module Serviz
  class Workflow < Base
    def self.step(service_class, params: nil, if: nil)
      @steps ||= []
      @steps << { service_class: service_class, params: params, condition: binding.local_variable_get(:if) }
    end

    def self.steps
      @steps ||= []
    end

    def initialize(*args, **kwargs)
      @last_result = nil
      @args = args
      @kwargs = kwargs
    end

    def call
      self.class.steps.each do |step_config|
        # Check if condition is provided and evaluate it
        if step_config[:condition] && !step_config[:condition].call(@last_result)
          next
        end

        # Determine parameters to use
        if step_config[:params]
          # Use step-specific params
          step_params = if step_config[:params].is_a?(Proc)
                          step_config[:params].call(self)
                        else
                          step_config[:params]
                        end
          result = step_config[:service_class].call(**step_params)
        else
          # Use workflow args/kwargs
          result = step_config[:service_class].call(*@args, **@kwargs)
        end
        
        # Accumulate errors if the service failed
        if result.failure?
          self.errors.concat(result.errors)
        end

        # Update last result and overall result
        @last_result = result
        self.result = result.result
      end

      self
    end
  end
end