class StaticPagesController < ApplicationController
  def home
  	if signed_in?
      @micropost  = current_user.microposts.build
      puts "StaticPagesController::home params[:page]: #{params[:page]}"
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
