require 'rails_helper'

RSpec.describe Workout::Type, type: :model do
  describe 'associations' do
    it { should have_many(:sessions) }
  end

  describe 'validations' do
    subject { build(:workout_type) }
    
    it { should validate_presence_of(:name) }
    
    describe 'uniqueness' do
      before { create(:workout_type) }
      
      it { should validate_uniqueness_of(:name) }
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:workout_type)).to be_valid
    end
  end

  describe '#generate_slug' do
    it 'generates slug from name before validation' do
      type = build(:workout_type, name: 'High Intensity Training')
      type.valid?
      expect(type.slug).to eq('high_intensity_training')
    end

    it 'handles special characters and spaces' do
      examples = {
        'HIIT & Cardio!' => 'hiit_cardio',
        'Strength  Training ' => 'strength_training',
        'Yoga-Flow 101' => 'yoga_flow_101',
        'Upper Body & Core' => 'upper_body_core'
      }

      examples.each do |name, expected_slug|
        type = build(:workout_type, name: name)
        type.valid?
        expect(type.slug).to eq(expected_slug)
      end
    end

    it 'ensures unique slugs for similar names' do
      create(:workout_type, name: 'Core Training')
      duplicate = build(:workout_type, name: 'Core Training')
      
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:slug]).to include('has already been taken')
    end

    it 'does not generate slug if name is blank' do
      type = build(:workout_type, name: '')
      type.valid?
      expect(type.slug).to be_nil
    end
  end
end 