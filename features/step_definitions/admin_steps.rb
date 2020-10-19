Given('I press {string} for {string}') do |button, row|
    # Find submission row in page
    elm = page.find("table tbody tr", text: row)

    # Press specified button
    elm.click_link(button)
end