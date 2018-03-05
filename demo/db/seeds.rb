Person.create!(handlename: "rails test1",
  sex:    0,
  syear:  2,
  bplace:                "Akita",
  name:                  "real name1",
  email:                 "example@railstutorial.org",
  tel:                   "000-1234-5678",
  password:              "foobar",
  password_confirmation: "foobar",
  admin:true,
  activated: true,
  activated_at: Time.zone.now)

Person.create!(handlename: "rails test2",
  sex:    1,
  syear:  1,
  bplace:                "Fukushima",
  name:                  "real name2",
  email:                 "example@foobar.net",
  tel:                   "001-2345-6789",
  password:              "foobaz",
  password_confirmation: "foobaz",
  activated: true,
  activated_at: Time.zone.now)


Person.create!(handlename: "test prof",
  sex:    1,
  syear:  0,
  bplace:                "Kanagawa",
  name:                  "professor Hoge",
  email:                 "example@professor.org",
  tel:                   "091-7825-6111",
  password:              "onakasuita",
  password_confirmation: "onakasuita",
  activated: true,
  activated_at: Time.zone.now)
  

  99.times do |n|
    handlename  = Faker::Name.initials
    sex = rand(0..1)
    syear = rand(1..4)
    bplace = Faker::Address.city
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    tel = Faker::Number.number(11)
    password = "password"
    Person.create!(handlename: handlename,
      sex: sex,
      syear: syear,
      bplace: bplace,
      name:  name,
      email: email,
      tel: tel,
      password:              password,
      password_confirmation: password,
      activated: true,
      activated_at: Time.zone.now)
    end


    people = Person.order(:created_at).take(6)
    50.times do
      content = Faker::Lorem.sentence(5)
      people.each { |person| person.microposts.create!(content: content) }
    end

    people = Person.all
    person  = people.first
    relationshipsA = people[2..50]
    relationshipsA.each { |personB| person.relation(personB) }
