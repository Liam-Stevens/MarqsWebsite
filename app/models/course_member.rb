class CourseMember < ApplicationRecord
  belongs_to :marker
  belongs_to :course, foreign_key: 'course_id'
end
