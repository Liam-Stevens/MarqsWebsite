Given('the following markers are in the database') do |table|
    # Create a marker for each row
    table.hashes.each do |row|
        m = Marker.new
        m.marker_id = row[:marker_id]
        m.first_name = row[:first_name]
        m.last_name = row[:last_name]
        m.save!
    end
end