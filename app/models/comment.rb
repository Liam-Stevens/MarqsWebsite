class Comment < ApplicationRecord
    belongs_to :submission, dependent: :destroy
    belongs_to :marker, foreign_key: 'marker_id'
end
