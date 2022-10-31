class Contact < ApplicationRecord
  validates :name, presence: true

  has_many :phone_numbers, dependent: :destroy
end
