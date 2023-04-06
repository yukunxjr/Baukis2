class Admin::Base < ApplicationController
    private def current_adimnstrator
      if session[:adimnstrator_id]
        @current_staff_member ||=
          Adimnstrator.find_by(id: session[:adimnstrator_id])
      end
    end
    helper_method :current_adimnstrator
end