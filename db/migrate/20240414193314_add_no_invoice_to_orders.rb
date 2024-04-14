class AddNoInvoiceToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :no_invoice, :boolean
  end
end
