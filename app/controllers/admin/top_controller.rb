class Admin::TopController < Admin::Base
    def index
        if current_adimnstrator
            render action: "dashboard"
        else
            render action: "index"
        end
    end
end
