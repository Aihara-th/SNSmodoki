class StaticpagesController < ApplicationController
  def home
      if logged_in?
      @micropost  = current_person.microposts.build
      @feed_items = current_person.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
