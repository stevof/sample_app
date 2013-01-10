class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :signed_in_user_prevent_signup, only: [:new, :create]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def destroy
    @user_to_delete = User.find(params[:id])
    puts
    puts "users_controller debug info:"
    puts "params[:id]: #{params[:id]}"
    puts "@user_to_delete: #{@user_to_delete.id}"
    puts "current_user.id: #{current_user.id}"

    # user should not be able to destroy himself
    if current_user?(@user_to_delete)
      puts "--Current user can't delete yourself"
      flash[:error] = "You cannot destroy yourself. What's your problem? Are you mentally unstable? Seek help immediately."
    else
      puts "--User deleted"
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_url
    puts
  end

  private

    def signed_in_user_prevent_signup
      if signed_in?
        redirect_to root_path,
                    notice: "You are already a user. Why are you trying to sign up again? Sign out if you want to do that. Geez."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
