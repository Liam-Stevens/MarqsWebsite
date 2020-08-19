class Course < ApplicationRecord
    self.primary_key = 'course_id'

    has_many :assignments, dependent: :destroy
    has_many :course_members, primary_key: 'course_id', foreign_key: 'course_id'
    has_many :markers, through: :course_members
end
