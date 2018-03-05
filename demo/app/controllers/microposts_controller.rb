class MicropostsController < ApplicationController
  before_action :logged_in_person, only: [:create, :destroy]
  before_action :correct_person,   only: :destroy

  def create
    @micropost = current_person.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      @geter = current_person
      po = current_person.point
      if current_person.syear <= 0
        tw = 1.5
      else
        tw = 1.0
      end
        po = po + 10*tw
      @geter.update_attribute( :point, po )
      redirect_to root_url
    else
      @feed_items = []
      render 'staticpages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

def update
  if current_person.count >= 5
    else
      @geter = current_person
      po = current_person.point
      po = po + 5
      co = current_person.count
      co += 1
      @geter.update_attribute(:point, po)
      @geter.update_attribute(:count, co)
    end
end

   def index
     @articles = Micropost.all
   end

  def page
    @article = Micropost.find(params[:id])
    @comment = Comment.new
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_person
      @micropost = current_person.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
