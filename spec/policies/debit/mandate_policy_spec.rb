require 'rails_helper'

RSpec.describe Debit::MandatePolicy, type: :policy do
  let(:user) { FactoryBot.build_stubbed(:user) }

  subject(:policy) { described_class.new(user, nil) }

  context '#create_with_user?' do
    it { expect(policy.create_with_user?(nil)).to be true }
  end

  context '#replace_user?' do
    it { expect(policy.replace_user?(nil)).to be true }
  end
end
