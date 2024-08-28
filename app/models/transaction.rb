class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validate :validate_transaction

  after_create :update_wallet_balances

  private

  def validate_transaction
    if transaction_type == 'Credit'
      errors.add(:source_wallet, 'must be nil') if source_wallet.present?
      errors.add(:target_wallet, 'must be present') unless target_wallet.present?
    elsif transaction_type == 'Debit'
      errors.add(:target_wallet, 'must be nil') if target_wallet.present?
      errors.add(:source_wallet, 'must be present') unless source_wallet.present?
      errors.add(:source_wallet, 'insufficient funds') if source_wallet&.balance < amount
    end
  end

  def update_wallet_balances
    if transaction_type == 'Credit'
      target_wallet.update(balance: target_wallet.balance + amount)
    elsif transaction_type == 'Debit'
      target_wallet.update(balance: source_wallet.balance - amount)
    end
  end
end
