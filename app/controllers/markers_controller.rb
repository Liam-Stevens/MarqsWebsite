class MarkersController < ApplicationController
    add_breadcrumb "Dashboard", :marker_path

    def show
        # Get list of courses for marker
        id = session[:id]
        @courses = Marker.find(id).courses
    end
end
