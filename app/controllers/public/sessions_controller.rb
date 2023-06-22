# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to restaurants_path, notice: "guestuserでログインしました。"
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  #ログイン後の画面の遷移先
  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインに成功しました！"
    restaurants_path
  end

  protected

  #退会後、同じアカウントは使用できないようにしている。
  def reject_user
    @user = User.find_by(name: params[:user][:name])
    if @user
      #パラメーターから送信され該当するユーザーをデータベースから取得する
      #valid_password?でユーザーが入力したパスワードが正しいかどうかを確認する
      if @user.valid_password?(params[:user][:password]) && (@user.is_deleted == false)
        flash[:notice] = "退会済みのためログインできません。再度ご登録をしてご利用ください。"
        redirect_to new_user_registoration
      else
        flash[:notice] = "項目を入力してください"
      end
    end
  end
end
