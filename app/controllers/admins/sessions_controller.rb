module Admins
  class SessionsController < ApplicationController
    skip_before_action :authenticate_admin!, only: [:new, :create]
    before_action :set_title, only: [:new]

    def new
      @admin = Admin.new
    end

    def create
      @admin = Admin.find_by(email: params[:admin][:email])
      if @admin&.authenticate(params[:admin][:password])
        session[:admin_id] = @admin.id
        redirect_to admin_root_path, notice: 'Login efetuado com sucesso.'
      else
        flash.now[:alert] = 'Email ou senha inválidos.'
        render :new
      end
    end

    def destroy
      session.delete(:admin_id)
      redirect_to root_path, notice: 'Logout efetuado com sucesso.'
    end

    private

    def set_title
      @title = 'Login'
    end
  end
end
