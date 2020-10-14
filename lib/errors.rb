module Errors 
    #Adds a single string into flash[:errors]
    def add_error(error)
        if flash[:errors].nil?
            flash[:errors] = []
        end
        flash[:errors].push(error)
    end

    #Adds an array of errors
    def add_error_array(error)
        if (flash[:errors].nil?)
            flash[:errors] = error
        else
            flash[:errors] += error
        end
    end
end