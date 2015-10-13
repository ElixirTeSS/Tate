class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def login_required
    false
  end

  def logged_in?
    true
  end

  def current_user
    if User.count < 1
      a = User.new
      a.name = "Bob"
      a.email = "Bobs@email.com"
      a.password = "N0H4CK3rS"
      a.save!
    end
    return User.first
  end

end
