class Assignment < ApplicationRecord
    default_scope {order("due_date ASC")}
    belongs_to :course
    has_many :submissions, dependent: :destroy

    validates :max_points , numericality: {greater_than_or_equal_to: 1, message: "max marks can't be zero"}, allow_nil: false
    validates :weighting , numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: "Mark must be in range [0,1] (greater than 0, less than or equal to 1)"}, allow_nil: false

    # Iterates through csv and saves new marks
    # returns array of errors if unable to save
    def self.import_marks(csv, assignment_id, marker_id)
        errors = []

        # Grab assignment and submissions
        assignment = Assignment.find(assignment_id)
        submissions = assignment.submissions

        # Setting students grades to imported grades
        csv.each do |row|
            submission = submissions.where(student_id: row["StudentID"]).first

            # Error if student is not found
            if submission == nil
                errors.push(row["StudentID"] + " " + "not found. Did not update")
                next
            end

            if row["Fix-Final-Mark"] != nil
                submission.grade = row["Fix-Final-Mark"]
                submission.marked_date = Date.today
            elsif row["Feedback-Mark"] != nil
                submission.grade = row["Feedback-Mark"]
                submission.marked_date = Date.today
            end

            unless submission.save
                submission.errors.messages[:grade].each do |msg|
                    errors.push(row["StudentID"] + ": " + msg)
                end
            end

            if row["Feedback-Comments"] != nil
                if Comment.find_by(submission_id: submission.id, content: row["Feedback-Comments"]) == nil
                    comment = Comment.new
                    comment.marker_id = marker_id
                    comment.submission_id = submission.id
                    comment.content = row["Feedback-Comments"]
                    comment.save!
                end
            end
        end
        
        if errors.length == 0
            errors.push("Successfully Imported!")
        end
        return errors
    end
end
