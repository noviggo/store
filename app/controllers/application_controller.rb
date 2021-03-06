class ApplicationController < ActionController::Base
  include ActionTitle
  include CurrentAccount
  include CurrentUser
  include UpdateResource

  protect_from_forgery with: :exception


  def authorize
    plug_mini_profiler

    redirect_to login_url, alert: t('messages.not_authorized') unless current_user
  end

  def user_for_paper_trail
    current_user.try :id
  end

  private

    def plug_mini_profiler
      Rack::MiniProfiler.authorize_request if current_user.try :is_admin?
    end
end
