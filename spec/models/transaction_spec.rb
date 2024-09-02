require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { User.create!(name: 'John Doe', email: 'john.doe@example.com', password: 'password123') }
  let(:team) { Team.create!(name: 'Team A', email: 'team@example.com', password_digest: SecureRandom.hex) } # Add password_digest with a dummy value
  let(:user_wallet) { Wallet.create!(entity: user, balance: 100.0) }
  let(:team_wallet) { Wallet.create!(entity: team, balance: 50.0) }

  it 'successfully transfers money from a User to a Team' do
    transaction = Transaction.create!(amount: 30.0, source_wallet: user_wallet, target_wallet: team_wallet, transaction_type: 'Debit')

    expect(user_wallet.reload.balance).to eq(70.0)
    expect(team_wallet.reload.balance).to eq(80.0)
  end

  it 'is invalid without a source wallet for Debit transactions' do
    transaction = Transaction.new(amount: 50.0, transaction_type: 'Debit', target_wallet: team_wallet)

    expect(transaction).to_not be_valid
    expect(transaction.errors[:source_wallet]).to include('must be present')
  end

  it 'is invalid without a target wallet for Credit transactions' do
    transaction = Transaction.new(amount: 50.0, transaction_type: 'Credit', source_wallet: user_wallet)

    expect(transaction).to_not be_valid
    expect(transaction.errors[:target_wallet]).to include('must be present')
  end

  it 'is invalid with insufficient funds for Debit transactions' do
    wallet_with_low_balance = Wallet.create!(entity: user, balance: 10.0)
    transaction = Transaction.new(amount: 50.0, transaction_type: 'Debit', source_wallet: wallet_with_low_balance, target_wallet: team_wallet)

    expect(transaction).to_not be_valid
    expect(transaction.errors[:source_wallet]).to include('insufficient funds')
  end
end
