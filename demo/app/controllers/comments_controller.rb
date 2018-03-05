class CommentsController < ApplicationController

  def create
    @article = Micropost.find(params[:micropost_id])
    @comment = @article.comments.create(comment_params)
    if @comment.errors.empty?
      @geter = current_person
      po = current_person.point
      if current_person.syear <= 0
        sw = 1.0
      else
        sw = 1.5
      end
      po = po + 10*sw
      @geter.update_attribute( :point, po )
      user = Person.find(@article.person_id)
      current_person.relation(user)
      redirect_to page_path(params[:micropost_id])
    else
      @article.comments.delete @comment
      render template: 'microposts/page'
    end
  end

  def destroy
    Comment.destroy(params[:id])
    redirect_to page_path(params[:micropost_id])
  end


  private

  def comment_params
    params.require(:comment).permit(:from, :body)
  end
end
