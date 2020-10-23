class MarkersController < ApplicationController
    add_breadcrumb "Dashboard", :marker_path
    before_action :show_session_redirect

    def show
        # Get list of courses for marker
        id = session[:id]
        @courses = Marker.find(id).courses
    end
end
