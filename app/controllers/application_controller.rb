class ApplicationController < ActionController::Base
    layout :set_layout

    private def set_layout
        if params[:controller].match(%r{\A(staff|admin|customer)/})
          Regexp.last_match[1]
        else
          "customer"
        end
    end

    private def reject_non_xhr
      raise ActionController::BadRequest unless request.xhr?
    end
end
