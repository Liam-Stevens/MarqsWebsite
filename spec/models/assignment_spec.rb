require 'rails_helper'

RSpec.describe Assignment, type: :model do
  let(:assignment) { submission = create(:assignment) } 
  context "max_points validation" do
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

  context "weighting validation" do
    it "accepts a weighting between (0,1]" do
      assignment.weighting = 0.1
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 0.2
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 0.3
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 0.4
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 0.56789
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 0.789098234
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 0.3940712834
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 0.98
      expect(assignment.valid?).to eq(true)
      assignment.weighting = 1
      expect(assignment.valid?).to eq(true)
    end

    it "does not accept a 0 weighting" do
      assignment.weighting = 0
      expect(assignment.valid?).to eq(false)
    end

    it "does not accept a negative weighting" do
      assignment.weighting = -0.1
      expect(assignment.valid?).to eq(false)
      assignment.weighting = -1
      expect(assignment.valid?).to eq(false)
      assignment.weighting = -2
      expect(assignment.valid?).to eq(false)
      assignment.weighting = -100
      expect(assignment.valid?).to eq(false)
      assignment.weighting = -2000
      expect(assignment.valid?).to eq(false)
    end

    it "does not accept a nil grade value" do
      assignment.weighting = nil
      expect(assignment.valid?).to eq(false)
    end

    it "raises an exception if invalid" do
      assignment.weighting = -1
      expect{assignment.save!}.to raise_exception
    end
  end
end
