module NavigationHelpers
    def path_to(page_name)
        case page_name
            when /^the home\s?page$/
                '/'

            when /^the login page$/
                '/login'

            when /^the admin page$/
                '/admin'

            when /^the home page for "(.*)"$/
                if (Student.exists?($1))
                    student_path($1)
                else
                    marker_path($1)
                end

            when /^the course page for "(.*)"$/
                course_path($1)

            when /^the marker's course page for "(.*)"$/
                course_marker_path($1)

            when /^the submissions page for the assignment "(.*)"$/
                # Get course ID from assignment
                assignment_path($1)

            when /^the submission page for id "(.*)"$/
                # Get IDs from parents
                submission_path($1)

            when /^the edit grade page for submission "(.*)"$/
                # Get IDs from parents
                edit_submission_path($1)

            when /^the add comment page for submission "(.*)"$/
                # Get IDs from parents
                new_submission_comment_path($1)

            when /^the edit comment page for "(.*)"$/
                edit_comment_path($1)

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