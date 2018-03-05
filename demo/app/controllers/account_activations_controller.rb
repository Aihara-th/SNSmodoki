class AccountActivationsController < ApplicationController

  def edit
    person = Person.find_by(email: params[:email])
    if person && !person.activated? && person.authenticated?(:activation, params[:id])
      person.activate
      log_in person
      flash[:success] = "Account activated!"
      redirect_to person
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
