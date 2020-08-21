class MarkersController < ApplicationController

    def index
        @courses = Course.all
    end

    def show
        id = params[:id]
        @marker = Marker.find(id)
        @courses = @marker.courses
    end
end
