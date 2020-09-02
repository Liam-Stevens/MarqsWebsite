class HomepageController < ApplicationController
    # Don't check if logged in on the home page
    skip_before_action :redirect_to_root

    def index
        # Proceed straight to student/marker homepage if logged in
    end
end