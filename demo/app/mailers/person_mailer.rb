class PersonMailer < ApplicationMailer

  def account_activation(person)
    @user = person
    mail to: person.email, subject: "Account activation"
  end

  def password_reset(person)
        @user = person
    mail to: person.email, subject: "Password reset"
  end
end
