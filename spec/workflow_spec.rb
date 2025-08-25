RSpec.describe Serviz::Workflow do
  describe "basic workflow execution" do
    it "executes steps in sequence and returns the last result" do
      workflow = Class.new(Serviz::Workflow) do
        step Step1, params: ->(instance) { { some_flag: instance.instance_variable_get(:@arg1) } }
        step Step2, params: ->(instance) { { some_flag: instance.instance_variable_get(:@arg2) } }

        def initialize(arg1, arg2)
          super()
          @arg1 = arg1
          @arg2 = arg2
        end
      end

      operation = workflow.call("test1", "test2")

      expect(operation.success?).to eq true
      expect(operation.result).to eq "step2_test2"
    end

    it "accumulates errors from failed steps" do
      workflow = Class.new(Serviz::Workflow) do
        step Step1, params: { some_flag: nil }  # This will fail
        step Step2, params: { some_flag: "test" }
      end

      operation = workflow.call

      expect(operation.failure?).to eq true
      expect(operation.errors).to include('Step1 failed')
    end
  end

  describe "conditional execution" do
    it "skips steps when condition is false" do
      workflow = Class.new(Serviz::Workflow) do
        step Step1, params: { some_flag: nil }  # This will fail
        step Step2, params: { some_flag: "test" }, if: ->(operation) { operation.success? }
      end

      operation = workflow.call

      expect(operation.failure?).to eq true
      expect(operation.errors).to eq(['Step1 failed'])
      expect(operation.result).to be_nil
    end

    it "executes steps when condition is true" do
      workflow = Class.new(Serviz::Workflow) do
        step Step1, params: { some_flag: "test1" }  # This will succeed
        step Step2, params: { some_flag: "test2" }, if: ->(operation) { operation.success? }
      end

      operation = workflow.call

      expect(operation.success?).to eq true
      expect(operation.result).to eq "step2_test2"
    end
  end
end
