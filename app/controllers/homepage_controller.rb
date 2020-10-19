class HomepageController < ApplicationController
    # Don't check if logged in on the home page
    skip_before_action :redirect_to_root
    before_action :unset_breadcrumb

    def unset_breadcrumb 
        @render_breadcrumb = false
    end

    def index
        # Proceed straight to student/marker homepage if logged in
        if session[:logged_in] == true
            redirect_to login_index_path
        end
    end
end
