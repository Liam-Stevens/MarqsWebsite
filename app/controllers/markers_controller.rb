class MarkersController < ApplicationController

    def show
        #Redirect for wrong URI
        if session[:id] != params[:id]
            redirect_to "/login"
        end

        id = session[:id]
        @marker = Marker.find(id)
        @courses = @marker.courses
    end
end
