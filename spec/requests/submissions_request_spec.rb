require 'rails_helper'

RSpec.describe "Submissions", type: :request do
  # Creates an assignment with 5 students
  before :each do
    @assignment = create(:assignment)
    @assignment.max_points = 100
    5.times do |id|
      student = create(:student, {student_id: id})
      @assignment.submissions.create({student_id: student.id})
    end
    @assignment.save!
  end

  context "Invalid Import marks" do
    it "Redirects to root" do 
      # I'm unsure if this actually performs the file upload or not
      # I can't inspect flash for some reason due to deprecation?? 
      post course_assignment_submission_import_path(@assignment.course_id, @assignment.id, -1), params: { grades: fixture_file_upload('csv_marks/valid.csv', 'csv/text') } 
      
      expect(response.status).to eq(302)
      # expect(flash[:errors]).to_not be_nil

      text = File.read("#{Rails.root}/spec/fixtures/csv_marks/valid.csv", encoding: 'utf-8')
      csv = CSV.parse(text, :headers => true)

      csv.each do |row|
        expect(@assignment.submissions.where({student_id: row["student_id"]})).to eq(row["fix_final_mark"].to_i)
      end
    end
  end
end
