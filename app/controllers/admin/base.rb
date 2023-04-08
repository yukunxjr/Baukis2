class Admin::Base < ApplicationController
  before_action :authorize
  before_action :check_account
  before_action :check_timeout

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

  private def check_account
    if current_adimnstrator && current_adimnstrator.suspended?
      session.delete(:adimnstrator_id)
      flash.alert = "アカウントが無効になりました。"
      redirect_to :admin_root
    end
  end

  TIMEOUT = 60.minute

  private def check_timeout
    if current_adimnstrator
      if session[:admin_last_access_time] >= TIMEOUT.ago
        session[:admin_last_access_time] = Time.current
      else
        session.delete(:adimnstrator_id)
        flash.alert = "セッションがタイムアウトしました。"
        redirect_to :admin_login
      end
    end
  end

  helper_method :current_adimnstrator
end