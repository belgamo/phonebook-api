class Contact < ApplicationRecord
  validates :name, presence: true

  has_many :phone_numbers, dependent: :destroy

  accepts_nested_attributes_for :phone_numbers, allow_destroy: true
end
