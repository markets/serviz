RSpec.describe Serviz::Base do
  it "operation success" do
    user = 'random_user'
    operation = RegisterUser.call(user)

    expect(operation.success?).to eq true
    expect(operation.failure?).to eq false
    expect(operation.errors).to be_empty
    expect(operation.result).to eq user
  end

  it "operation error" do
    operation = RegisterUser.call(nil)

    expect(operation.success?).to eq false
    expect(operation.failure?).to eq true
    expect(operation.errors).not_to be_empty
    expect(operation.result).to eq nil
  end

  it "raises exception if #call is not defined" do
    expect { NoCall.call }.to raise_error NotImplementedError
  end

  it "accepts positional and keywords args" do
    operation = PositionalAndKeyword.call('foo', keyword: 'bar')

    expect(operation.success?).to eq true
    expect(operation.result).to eq(['foo', 'bar'])
  end
end
