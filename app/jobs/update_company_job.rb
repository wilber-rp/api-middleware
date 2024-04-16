class UpdateCompanyJob < ApplicationJob
  queue_as :default

  def perform(order_id, cnpj)
    order = Order.find_by(id: order_id)
    url = "https://publica.cnpj.ws/cnpj/#{cnpj}"
    json_data = HTTParty.get(url, :headers =>{'Content-Type' => 'application/json'})
    if json_data['status'] != 429
      order.company_name = json_data['razao_social']
      order.address = "#{json_data['estabelecimento']['tipo_logradouro']} #{json_data['estabelecimento']['logradouro']}"
      order.number = json_data['estabelecimento']['numero']
      order.complement = json_data['estabelecimento']['complemento']
      order.neighborhood = json_data['estabelecimento']['bairro']
      order.city = json_data['estabelecimento']['cidade']['nome']
      order.state = json_data['estabelecimento']['estado']['sigla']
      order.zip_code = json_data['estabelecimento']['cep']
      if json_data["estabelecimento"].present? && json_data["estabelecimento"]["inscricoes_estaduais"].present?
        order.ie = json_data["estabelecimento"]["inscricoes_estaduais"].first["inscricao_estadual"]
      else
        order.ie = nil
      end
    else
      sleep(62)
      perform(order_id, cnpj)
    end
    order.save!
  end
end
