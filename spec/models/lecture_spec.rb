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

  it "cannot be changed after it ended" do
    @lecture.set_inactive
    expect(@lecture).to be_valid
    @lecture.save
    @lecture.description = @lecture.description + " new"
    expect { @lecture.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
    expect { @lecture.update(status: "running") }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end
end
