require "rails_helper"

RSpec.describe Lecture, type: :model do
  before (:each) do
    @lecture = FactoryBot.build(:lecture)
  end
  it "is creatable using a Factory" do
    expect(@lecture).to be_valid
  end

  it "is not valid without a name" do
    @lecture.name = ""
    expect(@lecture).not_to be_valid
  end

  it "is not valid without a enrollment key" do
    @lecture.enrollment_key = ""
    expect(@lecture).not_to be_valid
  end

  it "has all features enabled by default" do
    expect(@lecture.polls_enabled).to be true
    expect(@lecture.questions_enabled).to be true
  end

  it "new lectures have the status 'created' by default" do
    expect(@lecture.status).to eq "created"
  end

  it "can have participating students" do
    user1 = FactoryBot.create(:user, :student, email: "test1@hpi.de")
    user2 = FactoryBot.create(:user, :student, email: "test2@hpi.de")
    @lecture.participating_students << user1
    @lecture.participating_students << user2
  end

  it "each participating student is stored only once" do
    user = FactoryBot.create(:user, :student, email: "test1@hpi.de")
    expect(@lecture.participating_students.length).to be 0
    @lecture.join_lecture(user)
    expect(@lecture.participating_students.length).to be 1
    @lecture.join_lecture(user)
    expect(@lecture.participating_students.length).to be 1
  end

  it "student can leave lecture" do
    user = FactoryBot.create(:user, :student, email: "test1@hpi.de")
    @lecture.join_lecture(user)
    expect(@lecture.participating_students.length).to be 1
    @lecture.leave_lecture(user)
    expect(@lecture.participating_students.length).to be 0
  end

  it "is cannot be changed  when it ended" do
    isValid = @lecture.validate
    puts isValid
    lecture = FactoryBot.create(:lecture)
    lectureIsValid = lecture.validate
    puts lectureIsValid
    lecture.set_inactive
    lectureIsValid = lecture.validate
    puts lectureIsValid
    failed = lecture.save
    puts failed
    # db_lecture = Lecture.find_by_lecturer_id(lecture.id)
    lecture.description = lecture.description + " new"
    lectureIsValid = lecture.validate
    puts lectureIsValid
    expect(lecture).not_to be_valid
  end
end
