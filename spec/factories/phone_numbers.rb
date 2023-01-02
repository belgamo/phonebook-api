FactoryBot.define do
  factory :phone_number do
    number { rand.to_s[2..10] }
    number_type { 'cell' }
    
    contact
  end
end
