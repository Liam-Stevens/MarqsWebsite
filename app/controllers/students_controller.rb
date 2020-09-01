class StudentsController < ApplicationController
    def show
        @courses = @logged_in_user.courses
        @assignments = @courses[0].assignments
    end
end
