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

Given('the following markers are assigned to the courses') do |table|
    # Iterate over each row and assign marker to courses
    table.hashes.each do |row|
        # Split courses to get IDs
        ids = row[:courses].split(%r{,\s*})

        # Assign courses
        s = Marker.find(row[:marker_id])
        ids.each do |id|
            s.courses << Course.find(id)
        end
        s.save!
    end
end