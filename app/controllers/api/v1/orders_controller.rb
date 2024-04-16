class Api::V1::OrdersController < Api::V1::BaseController
  before_action :permissions_scope

  def index
    if params[:date].present?
      date_string = params[:date]
      date = Date.strptime(date_string, '%Y%m%d')
      @orders = Order.where(created_at: date.beginning_of_day..date.end_of_day).order(created_at: :asc)

    elsif params[:start].present? && params[:end].present?
      start_date = params[:start].present? ? Date.strptime(params[:start], '%Y%m%d') : Date.new(1970, 1, 1)
      end_date = params[:end].present? ? Date.strptime(params[:end], '%Y%m%d') : Date.today
      @orders = Order.where(created_at: start_date.beginning_of_day..end_date.end_of_day).order(created_at: :asc)

    else
      render_no_parameters
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)
    @order.payment_id = 1
    @order.source_id = 1
    if @order.save
      UpdateCompanyJob.perform_later(@order.id, @order.cnpj)
      render :show, status: :created
    else
      render_error
    end
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      UpdateCompanyJob.perform_later(@order.id, @order.cnpj)
      render :show
    else
      render_error
    end
  end

  private

  def order_params
    params.require(:order).permit(:order_number, :address, :model, :deceased_name,:costumer_full_name, :cpf, :company_name, :cnpj, :ie, :address, :number, :complement, :neighborhood, :city, :state, :zip_code, :email, :phone_number, :no_invoice )
  end

  def permissions_scope
    if request.method == 'GET' && (request.headers['xkey'] != ENV['READ_ONLY'] && request.headers['xkey'] != ENV['ADMIN'])
      render_no_access
    end
    if request.method == 'POST' && (request.headers['xkey'] != ENV['POST_ONLY'] && request.headers['xkey'] != ENV['ADMIN'])
      render_no_access
    end
    if request.method == 'PATCH' && request.headers['xkey'] != ENV['ADMIN']
      render_no_access
    end
  end

  def render_error
    render json: { errors: @order.errors.full_messages },
      status: :unprocessable_entity
  end

  def render_no_access
    render json: { error: "Sem permissão para realizar #{request.method}" },
    status: :unprocessable_entity
  end

  def render_no_parameters
    render json: { error: "Parametros necessários" },
    status: :unprocessable_entity
  end
end
