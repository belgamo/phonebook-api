class PhoneNumber < ApplicationRecord
  enum :number_type, %i(phone cell)

  validates :number, presence: true, length: { maximum: 9 }
  validates :number_type, presence: true

  belongs_to :contact
end
