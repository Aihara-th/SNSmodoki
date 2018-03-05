# coding: utf-8
module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(person)
    session[:person_id] = person.id
  end

  # ユーザーのセッションを永続的にする
  def remember(person)
    person.remember
    cookies.permanent.signed[:person_id] = person.id
    cookies.permanent[:remember_token] = person.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_person?(person)
    person == current_person
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_person
    if (person_id = session[:person_id])
      @current_person ||= Person.find_by(id: person_id)
    elsif (person_id = cookies.signed[:person_id])
      person = Person.find_by(id: person_id)
      if person && person.authenticated?(:remember, cookies[:remember_token])
        log_in person
        @current_person = person
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_person.nil?
  end

    # 現在のユーザーをログアウトする
  def log_out
    session.delete(:person_id)
    @current_person = nil
  end

    # 永続的セッションを破棄する
  def forget(person)
    person.forget
    cookies.delete(:person_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_person)
    session.delete(:person_id)
    @current_person = nil
  end

    # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
