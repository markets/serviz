module Serviz
  class Workflow < Base
    def self.step(service_class, params: nil, if: nil)
      steps << {
        service_class: service_class,
        params: params,
        condition: binding.local_variable_get(:if)
      }
    end

    def self.steps
      @steps ||= []
    end

    def initialize(*args, **kwargs)
      @last_step = nil
      @args = args
      @kwargs = kwargs
    end

    def call
      self.class.steps.each do |step_config|
        # Check if condition is provided and evaluate it
        if step_config[:condition] && !step_config[:condition].call(@last_step)
          next
        end

        # Determine parameters to use
        operation = if step_config[:params]
          # Use step-specific params
          step_params = if step_config[:params].is_a?(Proc)
                          step_config[:params].call(self)
                        else
                          step_config[:params]
                        end
          step_config[:service_class].call(**step_params)
        else
          # Use workflow args/kwargs
          step_config[:service_class].call(*@args, **@kwargs)
        end
        
        # Accumulate errors if the service failed
        if operation.failure?
          self.errors.concat(operation.errors)
        end

        # Update last result and overall result
        @last_step = operation
        self.result = operation.result
      end

      self
    end
  end
end
