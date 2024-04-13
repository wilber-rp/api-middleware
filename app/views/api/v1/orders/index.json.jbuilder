json.array! @orders do |order|
  json.extract! order, :id
  json.origem order.source[:name] # Renomeando a chave :name para "source_name"
end
