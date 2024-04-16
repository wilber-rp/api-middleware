json.array! @orders do |order|
  json.extract! order,  :id,
                        :order_number,
                        :model,
                        :deceased_name,
                        :costumer_full_name,
                        :cpf,
                        :company_name,
                        :cnpj,
                        :ie,
                        :address,
                        :number,
                        :complement,
                        :neighborhood,
                        :city,
                        :state,
                        :zip_code,
                        :email,
                        :phone_number,
                        :created_at
  json.origem order.source[:name] # Renomeando a chave :name para "source_name"
  json.extract! order.payment, :description, :installment
end
