class Student < ApplicationRecord
    has_and_belongs_to_many :courses
    has_many :submission, dependent: :destroy

    # Calculate a student's current grade for the given course
    def calculate_grade(course)
        assignments = course.assignments

        grades = []
        max_grades = []
        weightings = []

        assignments.each do |assignment|
            submission = assignment.submissions.find_by(student_id: id)
            max_grades.append(assignment.max_points)
            if (submission == nil)
                grades.append(0)
                weightings.append(0)
                next
            end
            grade = submission.grade

            if(grade != nil)
                grades.append(grade)
                weightings.append(assignment.weighting)
            end
        end

        sum_grade = 0
        sum_weightings = 0

        grades.each_with_index do |grade,index|
            sum_grade += (grades[index].to_f/max_grades[index].to_f)*(weightings[index]*100)
            sum_weightings += weightings[index]*100
        end

        if (sum_weightings == 0)
            current_grade = -1
        else
            current_grade = ((sum_grade/sum_weightings)*100).floor
        end

        # Restrict out of bounds values to 0
        if (current_grade < 0 || current_grade > 100)
            current_grade = 0
        end

        # Return grade value
        return current_grade
    end

    # Helper to concatenate name
    def full_name
        return first_name + " " + last_name
    end
end
