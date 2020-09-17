require 'rails_helper'

RSpec.describe Submission, type: :model do
  context "Submission grade validation" do
    let(:submission) { submission = create(:submission) }

    it "does not accept a negative value" do
      submission.grade = -1
      expect(submission.valid?).to eq(false)
    end

    it "does not accept a value greater than assignment max-points" do
      submission.assignment.max_points=100
      submission.assignment.save!
      submission.grade=101
      expect(submission.valid?).to eq(false)

      submission.grade=150
      expect(submission.valid?).to eq(false)

      submission.grade=1000
      expect(submission.valid?).to eq(false)
    end

    it "accepts a value that's within the assignment.max_points" do
      max_points = 100
      submission.assignment.max_points=max_points
      submission.assignment.save!
      max_points.times do |i|
        submission.grade=i
        expect(submission.valid?).to eq(true)
      end
    end

    it "accepts a nil grade value" do
      submission = create(:submission)
      expect(submission.valid?).to eq(true)
    end

    it "raises an exception if invalid" do
      submission.grade = -1
      expect{submission.save!}.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end
end
