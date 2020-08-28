class Marker < ApplicationRecord
    self.primary_key = 'marker_id'

    has_many :course_members
    has_many :courses, through: :course_members
    has_many :comments
end