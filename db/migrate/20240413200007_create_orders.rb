class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.string :model
      t.string :deceased_name
      t.string :costumer_full_name
      t.string :cpf
      t.string :company_name
      t.string :cnpj
      t.string :ie
      t.string :address
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :email
      t.string :phone_number
      t.references :source, null: false, foreign_key: true
      t.references :payment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
