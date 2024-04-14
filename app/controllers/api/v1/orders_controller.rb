class Api::V1::OrdersController < Api::V1::BaseController

  # before_action :set_order, only: [ :show, :update ]

  def index
    @orders = Order.all
  end
  
  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)
    @order.payment_id = 1
    @order.source_id = 1
    if @order.save
      url = "https://publica.cnpj.ws/cnpj/#{@order.cnpj}"
      json_data = HTTParty.get(url, :headers =>{'Content-Type' => 'application/json'})
      if json_data['status'] != 429
        @order.ie = json_data["estabelecimento"]["inscricoes_estaduais"].first["inscricao_estadual"]
        @order.address = "#{json_data['estabelecimento']['tipo_logradouro']} #{json_data['estabelecimento']['logradouro']}"
        @order.number = json_data['estabelecimento']['numero']
        @order.complement = json_data['estabelecimento']['complemento']
        @order.neighborhood = json_data['estabelecimento']['bairro']
        @order.city = json_data['estabelecimento']['cidade']['nome']
        @order.state = json_data['estabelecimento']['estado']['sigla']
        @order.zip_code = json_data['estabelecimento']['cep']
      else
        sleep(60)
        json_data = HTTParty.get(url, :headers =>{'Content-Type' => 'application/json'})
        @order.ie = json_data["estabelecimento"]["inscricoes_estaduais"].first["inscricao_estadual"]
        @order.address = "#{json_data['estabelecimento']['tipo_logradouro']} #{json_data['estabelecimento']['logradouro']}"
        @order.number = json_data['estabelecimento']['numero']
        @order.complement = json_data['estabelecimento']['complemento']
        @order.neighborhood = json_data['estabelecimento']['bairro']
        @order.city = json_data['estabelecimento']['cidade']['nome']
        @order.state = json_data['estabelecimento']['estado']['sigla']
        @order.zip_code = json_data['estabelecimento']['cep']
      end

      @order.save!
      render :show, status: :created
    else
      render_error
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      render :show
    else
      render_error
    end
  end

  private

  def order_params
    params.require(:order).permit(:order_number, :address, :model, :deceased_name,:costumer_full_name, :cpf, :company_name, :cnpj, :ie, :address, :number, :complement, :neighborhood, :city, :state, :zip_code, :email, :phone_number, :no_invoice )
  end

  def render_error
    render json: { errors: @order.errors.full_messages },
      status: :unprocessable_entity
  end
end
