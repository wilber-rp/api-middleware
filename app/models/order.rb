class Order < ApplicationRecord
  belongs_to :source
  belongs_to :payment

  validate :cpf_or_cnpj

  def cpf_or_cnpj
    errors.add(:base, "CPF ou CNPJ devem estar presentes") if cpf.nil? && cnpj.nil?
  end
end
