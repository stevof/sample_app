module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
  	!current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
  	# the "or equals" assignment calls the find_by_remember_token method 
  	# the first time current_user is called, but on subsequent invocations 
  	# returns @current_user without hitting the database.
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
