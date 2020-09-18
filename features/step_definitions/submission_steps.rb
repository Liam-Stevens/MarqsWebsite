Then('I should see a submission for {string}') do |student_id|
    # Find submission row in page
    elm = page.find("table tbody tr", text: student_id)
end

Given('I press {string} for the submission by {string}') do |button, student_id|
    # Find submission row in page
    elm = page.find("table tbody tr", text: student_id)

    # Press specified button
    elm.click_link(button)
end