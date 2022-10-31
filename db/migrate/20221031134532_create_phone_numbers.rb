class CreatePhoneNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :phone_numbers do |t|
      t.column :number_type, :integer
      t.column :number, :string

      t.timestamps
    end
  end
end
