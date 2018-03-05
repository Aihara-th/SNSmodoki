class RelationshipsController < ApplicationController
  before_action :logged_in_person

  def create
    @user = Person.find(params[:followed_id])
    current_person.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    if params[:commit] == 'OK' then
      val = 1
    elsif params[:commit] == 'SlightlyOK' then
      val = 2
    elsif params[:commit] == 'Rejection' then
      val = 3
    end
    @user = Relationship.find(params[:id]).personB
    current_person.recA(@user, val)
    @user = Relationship.find(params[:id]).personA
    current_person.recB(@user, val)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def update
    @user = Relationship.find(params[:id]).personB
    current_person.reqA(@user)
    @user = Relationship.find(params[:id]).personA
    current_person.reqB(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
