class Admin::Base < ApplicationController
  before_action :authorize

  private def current_adimnstrator
    if session[:adimnstrator_id]
      @current_staff_member ||=
      Adimnstrator.find_by(id: session[:adimnstrator_id])
    end
  end
  
  private def authorize
    unless current_adimnstrator
        flash.alert = "管理者としてログインしてください。"
        redirect_to :admin_login
    end
  end

  helper_method :current_adimnstrator
end