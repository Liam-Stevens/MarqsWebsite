module NavigationHelpers
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

            when /^the course page for "(.*)"$/
                course_path($1)

            when /^the marker's course page for "(.*)"$/
                course_marker_path($1)

            when /^the submissions page for the assignment "(.*)"$/
                # Get course ID from assignment
                course_id = Assignment.find($1).course_id
                course_assignment_submissions_path(course_id, $1)

            when /^the submission page for id "(.*)"$/
                # Get IDs from parents
                assignment_id = Submission.find($1).assignment_id
                course_id = Assignment.find(assignment_id).course_id
                course_assignment_submission_path(course_id, assignment_id, $1)

            when /^the edit grade page for submission "(.*)"$/
                # Get IDs from parents
                assignment_id = Submission.find($1).assignment_id
                course_id = Assignment.find(assignment_id).course_id
                edit_course_assignment_submission_path(course_id, assignment_id, $1)

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