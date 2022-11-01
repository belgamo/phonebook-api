class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :city
      t.datetime :birthday

      t.timestamps
    end

    add_reference :phone_numbers, :contact, foreign_key: true
  end
end
