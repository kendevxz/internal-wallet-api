class Wallet < ApplicationRecord
  belongs_to :entity
  has_many :source_transactions, class_name: 'Transaction', foreign_key: 'source_wallet_id'
  has_many :target_transactions, class_name: 'Transaction', foreign_key: 'target_wallet_id'

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
