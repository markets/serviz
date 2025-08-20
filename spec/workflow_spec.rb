RSpec.describe Serviz::Workflow do
  describe "basic workflow execution" do
    it "executes steps in sequence and returns the last result" do
      workflow = Class.new(Serviz::Workflow) do
        def initialize(arg1, arg2)
          super()
          @arg1 = arg1
          @arg2 = arg2
        end

        def call
          run Step1, params: { some_flag: @arg1 }
          run Step2, params: { some_flag: @arg2 }
        end
      end

      result = workflow.call("test1", "test2")

      expect(result.success?).to eq true
      expect(result.result).to eq "step2_test2"
    end

    it "accumulates errors from failed steps" do
      workflow = Class.new(Serviz::Workflow) do
        def call
          run Step1, params: { some_flag: nil }  # This will fail
          run Step2, params: { some_flag: "test" }
        end
      end

      result = workflow.call

      expect(result.failure?).to eq true
      expect(result.errors).to include('Step1 failed')
    end
  end

  describe "conditional execution" do
    it "skips steps when condition is false" do
      workflow = Class.new(Serviz::Workflow) do
        def call
          run Step1, params: { some_flag: nil }  # This will fail
          run Step2, params: { some_flag: "test" }, if: ->(result) { result.success? }
        end
      end

      result = workflow.call

      expect(result.failure?).to eq true
      expect(result.errors).to eq(['Step1 failed'])
      expect(result.result).to be_nil
    end

    it "executes steps when condition is true" do
      workflow = Class.new(Serviz::Workflow) do
        def call
          run Step1, params: { some_flag: "test1" }  # This will succeed
          run Step2, params: { some_flag: "test2" }, if: ->(result) { result.success? }
        end
      end

      result = workflow.call

      expect(result.success?).to eq true
      expect(result.result).to eq "step2_test2"
    end
  end

  describe "example from issue description style" do
    it "works with the issue example pattern using initialize" do
      sample_workflow = Class.new(Serviz::Workflow) do
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

      result = sample_workflow.call("value1", "value2")

      expect(result.success?).to eq true
      expect(result.result).to eq "step2_value2"
    end

    it "handles failure case from example" do
      sample_workflow = Class.new(Serviz::Workflow) do
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

      result = sample_workflow.call(nil, "value2")

      expect(result.failure?).to eq true
      expect(result.errors).to include('Step1 failed')
    end

    it "works with the concrete SampleWorkflow from scenarios" do
      result = SampleWorkflow.call("value1", "value2")

      expect(result.success?).to eq true
      expect(result.result).to eq "step2_value2"
    end

    it "handles SampleWorkflow failure case" do
      result = SampleWorkflow.call(nil, "value2")

      expect(result.failure?).to eq true
      expect(result.errors).to include('Step1 failed')
    end
  end

  describe "inheritance from Serviz::Base" do
    it "has the same interface as Serviz::Base" do
      workflow = Class.new(Serviz::Workflow) do
        def call
          run Step1, params: { some_flag: "test" }
        end
      end

      result = workflow.call

      expect(result).to respond_to(:success?)
      expect(result).to respond_to(:failure?)
      expect(result).to respond_to(:ok?)
      expect(result).to respond_to(:error?)
      expect(result).to respond_to(:errors)
      expect(result).to respond_to(:error_messages)
      expect(result).to respond_to(:result)
    end

    it "can be called with a block like other services" do
      workflow = Class.new(Serviz::Workflow) do
        def call
          run AlwaysFailStep
        end
      end

      expect {
        workflow.call { |operation| puts 'workflow failed!' if operation.failure? }
      }.to output("workflow failed!\n").to_stdout
    end
  end
end