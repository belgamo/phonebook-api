require 'rails_helper'

RSpec.describe Contact, :type => :model do
  subject{
    described_class.new(
      name: 'John'
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  describe "Associations" do
    it { should have_many(:phone_numbers) }
  end
end