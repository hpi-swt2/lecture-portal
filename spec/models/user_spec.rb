require 'rails_helper'

RSpec.describe User, type: :model do
  before (:each) do
    @user = FactoryBot.create(:user)
  end
  it "is creatable using a Factory" do
    expect(@user).to be_valid
  end

  it "is not valid without an email" do
    @user.email = ""
    expect(@user).to_not be_valid
  end

  it "is not valid without a password" do
    @user.password = ""
    expect(@user).not_to be_valid
  end

  it "is not valid without an is student status" do
    @user.is_student = ""
    expect(@user).not_to be_valid
  end

  it "(student) is not valid without a calender url" do
    skip("Needs to be checked if needed. But creation without hash_id is not possible, because it is added directly before. So only way of")
    @student = FactoryBot.create(:user, :student)
    @student.hash_id = ""
    expect(@student).not_to be_valid
  end

  it "(student) without hash_id is impossible" do
    @student = FactoryBot.create(:user, :student)
    @student.hash_id = nil
    @student.valid? # triggers validation which recreates the hash_id
    expect(@student.hash_id != nil)
  end

  it "can participate lectures" do
    @user.is_student = true
    lecture1 = FactoryBot.create(:lecture)
    lecture2 = FactoryBot.create(:lecture, lecturer: FactoryBot.build(:user, :lecturer, email: "test4@hpi.de"))
    @user.participating_lectures << lecture1
    @user.participating_lectures << lecture2
  end

  it "can have upvoted questions" do
    question1 = FactoryBot.create(:question, author: @user)
    question2 = FactoryBot.create(:question, author: @user)
    @user.upvoted_questions << question1
    @user.upvoted_questions << question2
  end

  it "can be destroyed" do
    expect { @user.destroy }.to_not raise_error
  end

  it "can be destroyed when referenced from uploaded_files" do
    course = FactoryBot.create(:course)
    FactoryBot.create(:uploaded_file, author: @user, allowsUpload_id: course.id, allowsUpload_type: "Course", data: "Something")
    expect { @user.destroy }.to_not raise_error
  end

  it "can be destroyed if user is a course member" do
    course = FactoryBot.create(:course)
    course.join_course(@user)
    expect { @user.destroy }.to_not raise_error
  end

  it "can be destroyed if user has joined a lecture" do
    lecture = FactoryBot.create(:lecture)
    lecture.join_lecture(@user)
    expect { @user.destroy }.to_not raise_error
  end
end
