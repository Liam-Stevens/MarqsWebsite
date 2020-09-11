module Errors 
    #Adds a single string into flash[:errors]
    def addError(error)
        if flash[:errors].nil?
            flash[:errors] = []
        end
        flash[:errors].push(error)
    end

    #Adds an array of errors
    def addErrorArray(error)
        if (flash[:errors].nil?)
            flash[:errors] = error
        else
            flash[:errors] += error
        end
    end
end