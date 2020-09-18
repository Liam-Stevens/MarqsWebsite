Given('I follow {string} for comment {string}') do |button, comment|
    # Find submission row in page
    elm = page.find("table tbody tr", text: comment)

    # Press specified button
    elm.click_link(button)
end