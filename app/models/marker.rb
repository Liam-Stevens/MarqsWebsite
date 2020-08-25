class Marker < ApplicationRecord
    has_many :course_members
    has_many :courses, through: :course_members
    has_many :comments
end