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
end
