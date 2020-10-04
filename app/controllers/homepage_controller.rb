class HomepageController < ApplicationController
    # Don't check if logged in on the home page
    skip_before_action :redirect_to_root

    add_breadcrumb "test", :root_path

    def index
        add_breadcrumb "test", login_index_path
        # Proceed straight to student/marker homepage if logged in
        if session[:logged_in] == true
            redirect_to login_index_path
        end
    end
end