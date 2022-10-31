require 'rails_helper'

RSpec.describe PhoneNumber, :type => :model do
  let(:contact) { Contact.new(name: 'John') }
  subject{
    described_class.new(
      number_type: 0, 
      number: '123456789', 
      contact: contact
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a number type" do
    subject.number_type = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a number" do
    subject.number = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a contact" do
    subject.contact = nil
    expect(subject).to_not be_valid
  end

  describe "Associations" do
    it { should belong_to(:contact) }
  end
end