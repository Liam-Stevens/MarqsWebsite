class MarkersController < ApplicationController
    def show
        # Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to login_path
        end

        # Get list of courses for marker
        id = session[:id]
        @courses = Marker.find(id).courses
    end
end
