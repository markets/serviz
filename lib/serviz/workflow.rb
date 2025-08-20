module Serviz
  class Workflow < Base
    def initialize(*args, **kwargs)
      @last_result = nil
    end

    def run(service_class, params: {}, if: nil)
      # Check if condition is provided and evaluate it
      if binding.local_variable_get(:if) && !binding.local_variable_get(:if).call(@last_result)
        return @last_result
      end

      # Execute the service
      result = service_class.call(**params)
      
      # Accumulate errors if the service failed
      if result.failure?
        self.errors.concat(result.errors)
      end

      # Update last result and overall result
      @last_result = result
      self.result = result.result

      result
    end
  end
end