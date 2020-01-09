    # This file should contain all the record creation needed to seed the database with its default values.
    # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
    #
    # Examples:
    #
    #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
    #   Character.create(name: 'Luke', movie: movies.first)
    Lecture.create(name: "swt", enrollment_key: "epic", status: "created")
    User.create(email: "user@example.com", password: "1234567890", password_confirmation: "1234567890")
