class PeopleController < ApplicationController
  before_action :logged_in_person, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_person,   only: [:edit, :update, :requestlist, :receivelist]
  before_action :admin_person,     only: :destroy

  def index
    @people = Person.where(activated: true).paginate(page: params[:page])
  end

    def ranking
    @people = Person.where(activated: true).order(point: :desc).paginate(page: params[:page])
  end

  def show
    @user = Person.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @room_id = message_room_id(current_person, @user)
    @messages = Message.recent_in_room(@room_id)
  end

  def message_room_id(first_person, second_person)
  first_id = first_person.id.to_i
  second_id = second_person.id.to_i
  if first_id < second_id
    "#{first_person.id}-#{second_person.id}"
  else
    "#{second_person.id}-#{first_person.id}"
  end
end

  def new
    @user = Person.new
  end

  def create
    @user = Person.new(person_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

 def edit
    @user = Person.find(params[:id])
  end

  def update
    @user = Person.find(params[:id])
    if @user.update_attributes(person_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    flash[:success] = "Person deleted"
    redirect_to people_url
  end

  def requestlist
    @title = "You can send request!"
    @user  = Person.find(params[:id])
    @people1 = @user.kankeiA.where("value > ? and sendA = ? and sendB = ? and waitA = ? and waitB = ?", 30, false, false, false, false )
    @people2 = @user.kankeiB.where("value > ? and sendA = ? and sendB = ? and waitA = ? and waitB = ?", 30, false, false, false, false )
    render 'show_request'
  end

  def receivelist
    @title = "You receive request!"
    @user  = Person.find(params[:id])
    @people1 = @user.kankeiA.where("sendB = ? and waitB = ? and disclosure = ?", true, true, 0)
    @people2 = @user.kankeiB.where("sendA = ? and waitA = ? and disclosure = ?", true, true, 0)
    render 'show_request'
  end

    private

      def person_params
        params.require(:person).permit(:handlename, :sex, :syear, :bplace, :name, :email, :tel,
                                       :password, :password_confirmation)
      end

      # 正しいユーザーかどうか確認
      def correct_person
        @user = Person.find(params[:id])
        redirect_to(root_url) unless current_person?(@user)
      end

      # 管理者かどうか確認
      def admin_person
        redirect_to(root_url) unless current_person.admin?
      end
end
