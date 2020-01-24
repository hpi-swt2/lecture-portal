require "rails_helper"

RSpec.describe Lecture, type: :model do
  let(:valid_attributes) {
    { name: "SWT", enrollment_key: "swt", status: "created", date: "2020-02-02", start_time: "2020-01-01 10:10:00", end_time: "2020-01-01 10:20:00", questions_enabled: true, polls_enabled: true }
  }
  let(:valid_attributes_with_description) {
    { name: "SWT", enrollment_key: "swt", status: "created", date: "2020-02-02", start_time: "2020-01-01 10:10:00", end_time: "2020-01-01 10:20:00", questions_enabled: true, polls_enabled: true, description: "description" }
  }
  let(:valid_attributes_with_lecturer) {
    valid_attributes.merge(lecturer: FactoryBot.create(:user, :lecturer, email: "test@test.de"))
  }
  let(:valid_attributes_with_lecturer_with_course) {
    valid_attributes_with_lecturer.merge(course: FactoryBot.create(:course))
  }

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

  it "is valid without an enrollment key" do
    @lecture.enrollment_key = ""
    expect(@lecture).to be_valid
  end

  it "is valid with an enrollment key with 3 characters" do
    @lecture.enrollment_key = "123"
    expect(@lecture).to be_valid
  end

  it "is not valid with an enrollment key with 1 to 2 characters" do
    @lecture.enrollment_key = "1"
    expect(@lecture).not_to be_valid

    @lecture.enrollment_key = "12"
    expect(@lecture).not_to be_valid
  end

  it "is not valid without a date" do
    @lecture.date = ""
    expect(@lecture).not_to be_valid
  end

  it "is not valid without a start time" do
    @lecture.start_time = ""
    expect(@lecture).not_to be_valid
  end

  it "is not valid without a end time" do
    @lecture.end_time = ""
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

  it "cannot be changed after it was archived" do
    @lecture.set_archived
    expect(@lecture).to be_valid
    @lecture.save
    @lecture.description = @lecture.description + " new"
    expect { @lecture.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
    expect { @lecture.update(status: "running") }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it "can be changed before it ended" do
    @lecture.set_active
    expect(@lecture).to be_valid
    @lecture.save
    @lecture.description = @lecture.description + " new"
    expect(@lecture.save).to be_truthy
    expect(@lecture.update(status: "running")).to be_truthy
  end


  describe "comprehension_state" do
    context "as student" do
      before(:each) do
        @user = FactoryBot.create(:user, :student)
        @lecture.join_lecture(@user)
      end
      it "returns correct comprehension level" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture)
        expect(@lecture.comprehension_state(@user).to_json).to eq({ status: stamp.status, last_update: stamp.timestamp }.to_json)
      end
      it "returns empty comprehension level" do
        expect(@lecture.comprehension_state(@user)).to eq({ status: -1, last_update: nil })
      end

      it "returns empty comprehension level if too old" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture, updated_at: Time.now - LectureComprehensionStamp.seconds_till_comp_timeout)
        expect(@lecture.comprehension_state(@user).to_json).to eq({ status: -1, last_update: stamp.timestamp }.to_json)
      end
    end

    context "as lecturer" do
      before(:each) do
        @lecture = Lecture.create! valid_attributes_with_lecturer_with_course
        @user = FactoryBot.create(:user, :student)
        @lecturer = @lecture.lecturer
      end
      it "returns correct comprehension level" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture)
        expect(@lecture.comprehension_state(@lecturer).to_json).to eq({ status: [1, 0, 0], last_update: stamp.timestamp }.to_json)
      end
      it "returns correct comprehension level distribution" do
        LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture)
        LectureComprehensionStamp.create(user: FactoryBot.create(:user, :student), status: 1, lecture: @lecture)
        LectureComprehensionStamp.create(user: FactoryBot.create(:user, :student), status: 2, lecture: @lecture)
        stamp_last = LectureComprehensionStamp.create(user: FactoryBot.create(:user, :student), status: 0, lecture: @lecture)
        expect(@lecture.comprehension_state(@lecturer).to_json).to eq({ status: [2, 1, 1], last_update: stamp_last.timestamp }.to_json)
      end
      it "returns empty comprehension level" do
        expect(@lecture.comprehension_state(@lecturer)).to eq({ status: [0, 0, 0], last_update: nil })
      end

      it "returns empty comprehension level if too old" do
        stamp = LectureComprehensionStamp.create(user: @user, status: 0, lecture: @lecture, updated_at: Time.now - LectureComprehensionStamp.seconds_till_comp_timeout)
        expect(@lecture.comprehension_state(@lecturer).to_json).to eq({ status: [0, 0, 0], last_update: stamp.timestamp }.to_json)
      end
    end
  end
end
