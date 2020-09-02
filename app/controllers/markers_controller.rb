class MarkersController < ApplicationController
    def index
        @courses = Course.all
    end

    def show
        # Get list of courses for marker
        id = params[:id]
        @courses = Marker.find(id).courses
    end
end
