class Person < ApplicationRecord
  has_many :from_messages, class_name: "Message",
  foreign_key: "from_id", dependent: :destroy
  has_many :to_messages, class_name: "Message",
  foreign_key: "to_id", dependent: :destroy
  has_many :sent_messages, through: :from_messages, source: :from
  has_many :received_messages, through: :to_messages, source: :to
  has_many :microposts, dependent: :destroy
  has_many :relationshipsA, class_name:  "Relationship",
                            foreign_key: "personA_id",
                            dependent:   :destroy
  has_many :relationshipsB, class_name:  "Relationship",
                            foreign_key: "personB_id",
                            dependent:   :destroy
  has_many :kankeiA, through: :relationshipsA, source: :personB
  has_many :kankeiB, through: :relationshipsB, source: :personA
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  before_save { email.downcase! }
  validates :handlename, presence: true, length: { maximum: 50 }
  validates :sex, inclusion: { in: [true, false]}
  validates :syear, presence: true, length: { maximum: 5 }
  validates :bplace, presence: true, length: { maximum: 50 }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :tel, presence: true, length: { maximum: 50 }


    # 渡された文字列のハッシュ値を返す
  def Person.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


  # ランダムなトークンを返す
  def Person.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = Person.new_token
    update_attribute(:remember_digest, Person.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    PersonMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = Person.new_token
    update_columns(reset_digest:  Person.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    PersonMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where("person_id = ?", id)
  end

  # Send message to other user
def send_message(other_person, room_id, content)
  from_messages.create!(to_id: other_person.id, room_id: room_id, content: content)
end

  #関係の作成
  def relation(other_person)
    if self.id < other_person.id then
      if involved?(other_person) == false then
        relationshipsA.create(personB_id: other_person.id, value: 1)
      else
        @relA = relationshipsA.find_by(personB_id: other_person.id)
        po = @relA.value
        po += 1
        @relA.update_attribute( :value, po )
      end
    elsif self.id > other_person.id then
      if involved1?(other_person) == false then
        relationshipsB.create(personA_id: other_person.id, value: 1)
      else
        @relB = relationshipsB.find_by(personA_id: other_person.id)
        po = @relB.value
        po += 1
        @relB.update_attribute( :value, po )
      end
    else
    end
  end

  def reqA(other_person)
    @arrA = relationshipsA.find_by(personB_id: other_person.id)
    if @arrA.nil?
    else
      @arrA.update_attributes(sendA: true, waitA: true)
    end
  end

  def reqB(other_person)
    @arrB = relationshipsB.find_by(personA_id: other_person.id)
    if @arrB.nil?
    else
      @arrB.update_attributes(sendB: true, waitB: true)
    end
  end

    def recA(other_person, val)
    @arA = relationshipsA.find_by(personB_id: other_person.id)
    if @arA.nil?
    else
      @arA.update_attributes(disclosure: val)
    end
  end

  def recB(other_person, val)
    @arB = relationshipsB.find_by(personA_id: other_person.id)
    if @arB.nil?
    else
      @arB.update_attributes(disclosure: val)
    end
  end

  # 現在のユーザーが関係を作成してたらtrueを返す
  def involved?(other_person)
    kankeiA.include?(other_person)
  end

  def involved1?(other_person)
    kankeiB.include?(other_person)
  end

def allA?(other_person)
  if relationshipsA.find_by(personB_id: other_person.id).nil?
    false
  elsif relationshipsA.find_by(personB_id: other_person.id).sendB == false  && \
        relationshipsA.find_by(personB_id: other_person.id).sendA == false then
    true
  else
    false
  end
end

def allB?(other_person)
  if relationshipsB.find_by(personA_id: other_person.id).nil?
    false
  elsif relationshipsB.find_by(personA_id: other_person.id).sendB == false  && \
        relationshipsB.find_by(personA_id: other_person.id).sendA == false then
    true
  else
    false
  end
end

def sendedA?(other_person)
  if relationshipsA.find_by(personB_id: other_person.id).nil?
    false
  elsif relationshipsA.find_by(personB_id: other_person.id).sendB == true  && \
        relationshipsA.find_by(personB_id: other_person.id).sendA == false then
    true
  else
    false
  end
end

def sendedB?(other_person)
  if relationshipsB.find_by(personA_id: other_person.id).nil?
    false
  elsif relationshipsB.find_by(personA_id: other_person.id).sendA == true && \
        relationshipsB.find_by(personA_id: other_person.id).sendB == false then
    true
  else
    false
  end
end

def disclosureA?(other_person)
  if relationshipsA.find_by(personB_id: other_person.id).nil?
    false
  elsif relationshipsA.find_by(personB_id: other_person.id).disclosure == 0 then
    false
  else
    true
  end
end

def disclosureB?(other_person)
  if relationshipsB.find_by(personA_id: other_person.id).nil?
    false
  elsif relationshipsB.find_by(personA_id: other_person.id).disclosure == 0 then
    false
  else
    true
  end
end

  #現在のユーザーと相手のユーザーのrelationのvalueの値が30以上であるかどうかを確認する
  def canrequestA?(other_person)
    if relationshipsA.find_by(personB_id: other_person.id).nil? then
      false
    elsif relationshipsA.find_by(personB_id: other_person.id).value >= 30 && allA?(other_person) then
      true
    else
      false
    end
  end

  #現在のユーザーと相手のユーザーのrelationのvalueの値が30以上であるかどうかを確認する
  def canrequestB?(other_person)
    if relationshipsB.find_by(personA_id: other_person.id).nil? then
      false
    elsif relationshipsB.find_by(personA_id: other_person.id).value >= 30 && allB?(other_person) then
      true
    else
      false
    end
  end

    private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = Person.new_token
      self.activation_digest = Person.digest(activation_token)
    end

end
