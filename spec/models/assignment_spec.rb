require 'rails_helper'

RSpec.describe Assignment, type: :model do
  context "max_points validation" do
    let(:assignment) { submission = create(:assignment) } 

    it "accepts a positive value" do
      assignment.max_points = 2000
      expect(assignment.valid?).to eq(true)
      assignment.max_points = 100
      expect(assignment.valid?).to eq(true)
      assignment.max_points = 1
      expect(assignment.valid?).to eq(true)
    end

    it "does not accept a negative value" do
      assignment.max_points = -1
      expect(assignment.valid?).to eq(false)
      assignment.max_points = -1000
      expect(assignment.valid?).to eq(false)
    end

    it "does not accept zero as a value" do
      assignment.max_points = 0;
      expect(assignment.valid?).to eq(false)
    end

    it "does not accept a nil grade value" do
      assignment.max_points = nil;
      expect(assignment.valid?).to eq(false)
    end

    it "throws an Active:RecordInvalid exception if invalid" do
      assignment.max_points = 0;
      expect { assignment.save! }.to raise_exception
    end
  end
end
