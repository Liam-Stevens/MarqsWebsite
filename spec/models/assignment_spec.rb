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
      expect { assignment.save! }.to raise_exception(ActiveRecord::RecordInvalid)
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

    it "does accept a 0 weighting" do
      assignment.weighting = 0
      expect(assignment.valid?).to eq(true)
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
      expect{assignment.save!}.to raise_exception(ActiveRecord::RecordInvalid)
    end
  end

  context "importing marks" do
    before(:each) do
      # Create assignment of 1.
      assignment = create(:assignment, {id: 1, max_points: 100})

      # Create 5 students that have this assignment.
      [1,2,3,4,5].each do | i |
        create(:submission, { assignment: assignment, student: create(:student, id: i) } )
      end
    end

    # Gets a csv file from spec/csv
    def get_csv(file)
      text = File.read(Rails.root.join('spec','csv', file), :encoding => 'utf-8')
      csv = CSV.parse(text, :headers => true)
      return csv
    end

    it "raises an ActiveRecord:RecordNotFound if no assignment found" do
      csv = get_csv("1_mark.csv")
      expect{Assignment.import_marks(csv, 999999, 1)}.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "saves one student" do
      csv = get_csv("1_mark.csv")
      errors = Assignment.import_marks(csv, 1, 1)
      expect(Assignment.find(1).submissions.where(student_id: 1).first.grade).to eq(50)
    end

    it "saves four students" do
      csv = get_csv("5_mark.csv")
      errors = Assignment.import_marks(csv, 1, 1)
      [1,2,3,4,5].each do |i|
        expect(Assignment.find(1).submissions.where(student_id: i).first.grade).to eq(50)
      end
    end

    it "responds with error if can't find student" do
      csv = get_csv("no_student.csv")
      errors = Assignment.import_marks(csv, 1, 1)
      expect(errors.length).to eq(1)
      expect(errors[0]).to match(/7/)
      expect(errors[0]).to match(/not found/)
    end

    it "responds with error if negative marks" do
      csv = get_csv("negative_marks.csv")
      errors = Assignment.import_marks(csv, 1, 1)
      expect(errors.length).to eq(1)
      expect(errors[0]).to match(/3/)
      expect(errors[0]).to match(/negative/)
    end

    it "responds with error if marks over max points" do
      csv = get_csv("over_max.csv")
      errors = Assignment.import_marks(csv, 1, 1)
      expect(errors.length).to eq(1)
      expect(errors[0]).to match(/3/)
      expect(errors[0]).to match(/max/)
    end

    it "responds with error if marks not a valid number" do
      csv = get_csv("non_number.csv")
      errors = Assignment.import_marks(csv, 1, 1)
      expect(errors.length).to eq(1)
      expect(errors[0]).to match(/3/)
      expect(errors[0]).to match(/number/)
    end

    it "propagates multiple errors" do
      csv = get_csv("multiple_errors.csv")
      errors = Assignment.import_marks(csv, 1, 1)
      expect(errors.length).to eq(3)
    end
  end
end
