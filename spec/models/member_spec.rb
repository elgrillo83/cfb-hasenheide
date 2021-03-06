require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:user) { create(:user) }
  let(:member) { create :member, user: user }

  describe '#user' do
    it 'has user relation' do
      expect(member.user).to eq(user)
    end
  end

  describe '#contact' do
    it 'has a contact relation' do
      expect(member.contact)
    end
  end

  describe '#address' do
    it 'has a address relation' do
      expect(member.address)
    end
  end

  describe '.create' do
    subject do
      Member.create!(user_id: user.id)
    end

    it 'has a auto generated contact model' do
      expect(subject.contact.persisted?).to be_truthy
    end
  end
end
