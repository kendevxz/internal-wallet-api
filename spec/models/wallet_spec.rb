RSpec.describe Wallet, type: :model do
  it 'can belong to a User' do
    user = User.create!(email: 'john.doe@example.com', password: 'password123')
    wallet = Wallet.create!(entity: user, balance: 100.0)
    expect(wallet.entity).to eq(user)
  end

  it 'can belong to a Team' do
    team = Team.create!(name: 'Team A', email: 'team.a@example.com')
    wallet = Wallet.create!(entity: team, balance: 200.0)
    expect(wallet.entity).to eq(team)
  end
end
