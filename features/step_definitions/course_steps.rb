Given('I press {string} for the course {string}') do |button, course|
    # Find course row in page
    elm = page.find("table tbody tr", text: course)

    # Press 'button'
    elm.click_link(button)
end