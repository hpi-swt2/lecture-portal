    # This file should contain all the record creation needed to seed the database with its default values.
    # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

    lecturer_1 = User.create(is_student: false, email: "lecturer-1@hpi.de", password: "1234567890", password_confirmation: "1234567890", hash_id: "1")
    User.create(is_student: true, email: "student-1@hpi.de", password: "1234567890", password_confirmation: "1234567890", hash_id: "2")
    User.create(is_student: true, email: "student-2@hpi.de", password: "1234567890", password_confirmation: "1234567890", hash_id: "3")

    course_1 = Course.create(name: "<Kurs-1>", description: "Testkurs #1", creator: lecturer_1)

    Lecture.create(name: "<Created Lecture>", enrollment_key: "epic", status: "created", lecturer: lecturer_1, course: course_1, date: Date.tomorrow, start_time: "2020-01-01 10:00:00", end_time: "2020-01-01 15:00:00")
    Lecture.create(name: "<Active Lecture>", enrollment_key: "epic", status: "active", lecturer: lecturer_1, course: course_1, date: Date.today, start_time: "2020-01-01 00:00:00", end_time: "2020-01-01 00:00:01")
    Lecture.create(name: "<Running Lecture>", enrollment_key: "epic", status: "running", lecturer: lecturer_1, course: course_1, date: Date.today, start_time: DateTime.now, end_time: "2020-01-01 23:59:59")
    Lecture.create(name: "<Archived Lecture>", enrollment_key: "epic", status: "archived", lecturer: lecturer_1, course: course_1, date: Date.yesterday, start_time: "2020-01-01 10:00:00", end_time: "2020-01-01 15:00:00")
