class Comment < ApplicationRecord
    belongs_to :submission
    belongs_to :marker, foreign_key: 'marker_id'
end
