require 'rails_helper'

RSpec.describe Debit::TransactionPolicy, type: :policy do
  let(:user) { FactoryBot.build_stubbed(:user) }

  subject(:policy) { described_class.new(user, nil) }

  context '#create_with_user?' do
    it { expect(policy.create_with_user?(nil)).to be true }
  end

  context '#replace_user?' do
    it { expect(policy.replace_user?(nil)).to be true }
  end

  context '#create_with_collection?' do
    it { expect(policy.create_with_collection?(nil)).to be true }
  end

  context '#replace_collection?' do
    it { expect(policy.replace_collection?(nil)).to be true }
  end
end
