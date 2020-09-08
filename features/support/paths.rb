module NavigationHelpers
    # Maps a name to a path. Used by the
    #
    #   When /^I go to (.+)$/ do |page_name|
    #
    # step definition in web_steps.rb
    #
    def path_to(page_name)
        case page_name

            when /^the home\s?page$/
                '/'

            when /^the login page$/
                '/login'

            when /^the home page for "(.*)"$/
                if (Student.exists?($1))
                    student_path($1)
                else
                    marker_path($1)
                end

            when /^the "(.*)" course page for "(.*)"$/
                student_course_path($2, $1)

        # Add more mappings here.
        # Here is an example that pulls values out of the Regexp:
        #
        #   when /^(.*)'s profile page$/i
        #     user_profile_path(User.find_by_login($1))

        else
            begin
                page_name =~ /^the (.*) page$/
                path_components = $1.split(/\s+/)
                self.send(path_components.push('path').join('_').to_sym)
                rescue NoMethodError, ArgumentError
                raise "Can't find mapping from \"#{page_name}\" to a path.\nNow, go and add a mapping in #{__FILE__}"
            end
        end
    end
end

World(NavigationHelpers)