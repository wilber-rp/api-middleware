class Order < ApplicationRecord
  belongs_to :source
  belongs_to :payment

  validates :order_number, presence: true
  validates :model, presence: true
  validates :deceased_name, presence: true
  validates :costumer_full_name, presence: true

  validate :cpf_or_cnpj
  # validates :company_name, presence: true

  validates :address, presence: true, if: :cpf_present?
  validates :number, presence: true, if: :cpf_present?
  validates :neighborhood, presence: true, if: :cpf_present?
  validates :city, presence: true, if: :cpf_present?
  validates :state, presence: true, if: :cpf_present?
  validates :zip_code, presence: true, if: :cpf_present?

  validates :email, presence: true
  validates :phone_number, presence: true
  validates :no_invoice, inclusion: { in: [true, false], message: "Campo no_invoice deve ser preenchido" }

  def cpf_or_cnpj
    errors.add(:base, "CPF ou CNPJ deve estar presente") if cpf.nil? && cnpj.nil?
    if cpf? && cpf.size != 11
      errors.add(:base, "CPF inválido")
    end
    if cnpj? && cnpj.size != 14
      errors.add(:base, "CNPJ inválido")
    end
  end

  def cpf_present?
    cpf.present?
  end
end
