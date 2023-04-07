class Admin::SessionsController < Admin::Base
    def new
        if current_adimnstrator
          redirect_to :admin_root
        else
          @form = Admin::LoginForm.new
          render action: "new"
        end
    end

    def create
        @form = Admin::LoginForm.new(params[:admin_login_form])
        if @form.email.present?
            adimnstrator =
                Adimnstrator.find_by("LOWER(email) = ?", @form.email.downcase)
        end
        if Admin::Authenticator.new(adimnstrator).authenticate(@form.password)
            if adimnstrator.suspended?
                flash.now.alert = "アカウントが停止されています。"
                render action: "new"
            else
                session[:adimnstrator_id] = adimnstrator.id
                flash.notice = "ログインしました。"
                redirect_to :admin_root
            end
        else
            flash.now.alert = "メールアドレスまたはパスワードが正しくありません。"
            render action: "new"
        end
    end

    def destroy
        session.delete(:adimnstrator_id)
        flash.notice = "ログアウトしました。"
        redirect_to :admin_root
    end
end
