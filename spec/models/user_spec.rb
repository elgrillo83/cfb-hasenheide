require 'rails_helper'

describe User do
  let(:user) { create :user }
  let(:role) { create :role }

  context 'roles assignable to users' do
    it 'assigns the role to the user' do
      expect do
        user.roles << role
        user.save
      end.to change { user.functions.count }.from(0).to(1)
    end
  end

  describe '#current_function' do
    before do
      user.assign_role role, start_date, end_date
    end

    context 'user has a current function' do
      let(:start_date) { Time.zone.today - 10.days }
      let(:end_date) { Time.zone.today + 2.days }

      it 'returns the current function' do
        expect(user.current_functions.first.name).to eq(role.name)
      end
    end

    context 'user was in function' do
      let(:start_date) { Time.zone.today - 10.days }
      let(:end_date) { Time.zone.today - 2.days }

      it 'returns nil' do
        expect(user.current_functions).to eq([])
      end
    end
  end

  describe '#address' do
    it 'user references to address' do
      expect(user.address)
    end

    it 'user address can be assigned' do
      address = create :address
      user.address = address
      expect(user.save).to be_truthy
      expect(user.reload.address).to eq(address)
    end
  end

  describe '#player?' do
    let(:player_profile) { build :player }

    it 'returns true if user has a player relation' do
      user.player = player_profile
      user.save
      expect(user.reload.player?).to be_truthy
    end

    it 'returns false if user has no player assigned' do
      expect(user.reload.player?).to be_falsy
    end
  end

  describe '#contact' do
    it 'has a contact' do
      expect(user.contact)
    end
  end

  describe '#member' do
    it 'has a member' do
      expect(user.contact)
    end
  end
end
