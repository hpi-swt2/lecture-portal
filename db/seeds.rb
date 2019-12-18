    # This file should contain all the record creation needed to seed the database with its default values.
    # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

    lecturer_1 = User.create(is_student: false, email: "lecturer-1@hpi.de", password: "1234567890", password_confirmation: "1234567890")
    student_1 = User.create(is_student: true, email: "student-1@hpi.de", password: "1234567890", password_confirmation: "1234567890")

    Lecture.create(name: "<Created Lecture>", enrollment_key: "epic", status: "created", lecturer: lecturer_1)
    Lecture.create(name: "<Running Lecture>", enrollment_key: "epic", status: "running", lecturer: lecturer_1)
    Lecture.create(name: "<Ended Lecture>", enrollment_key: "epic", status: "ended", lecturer: lecturer_1)
