require "rails_helper"

RSpec.describe UploadedFilesController, type: :controller do
  before :each do
    file = fixture_file_upload("files/LICENSE", "text/plain")
    @lecturer = FactoryBot.create(:user, :lecturer)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    @file = Hash.new
    @file["uploaded_file"] = Hash.new
    @file["uploaded_file"]["attachment"] = file
    @file["uploaded_file"]["lecture"] = @lecture.id
    @file["lecture_id"] = @lecture.id
    @file["course_id"] = @lecture.course.id
    @course = @lecture.course
    sign_in @lecturer
  end
  it "returns success" do
    post :create, params: @file
    expect(response).to redirect_to(course_lecture_path(@course, @lecture))
  end

  it "stores the file" do
    old_count = UploadedFile.count
    post :create, params: @file
    expect(response).to redirect_to(course_lecture_path(@course, @lecture))
    expect(UploadedFile.count).to eq(old_count + 1)
  end

  it "requires authentication" do
    sign_out @lecturer
    old_count = UploadedFile.count
    post :create, params: @file
    expect(response).to_not redirect_to(course_lecture_path(@course, @lecture))
    expect(UploadedFile.count).to eq(old_count)
  end

  it "stores the file only if valid file provided" do
    old_count = UploadedFile.count
    @file["uploaded_file"].except!("attachment")
    post :create, params: @file
    expect(response).to_not redirect_to(course_lecture_path(@course, @lecture))
    expect(UploadedFile.count).to eq(old_count)
  end

  context "having a file uploaded to a course as a student" do
    before :each do
        @student = FactoryBot.create(:user, :student)
        @lecturer = FactoryBot.create(:user, :lecturer)
        @course = FactoryBot.create(:course, creator: @lecturer)
        @student_file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload: @course, data: "Some Text")
        sign_in @student
      end

    it "can be deleted by the owner" do
      expect { post :destroy, params: { id: @student_file[:id], lecture_id: @lecture.id, course_id: @course.id } }.to change(UploadedFile, :count).by(-1)
    end

    it "can be deleted by the course owner" do
      sign_in @lecturer
      expect { post :destroy, params: { id: @student_file[:id], lecture_id: @lecture.id, course_id: @course.id } }.to change(UploadedFile, :count).by(-1)
    end

    it "can't be deleted by someone else" do
      @other_lecturer = FactoryBot.create(:user, :lecturer)
      sign_in @other_lecturer
      expect { post :destroy, params: { id: @student_file[:id], lecture_id: @lecture.id, course_id: @course.id } }.to_not change(UploadedFile, :count)
    end
  end

  context "deleting a lecture file as a student" do
    before :each do
        @student = FactoryBot.create(:user, :student)
        @lecturer = FactoryBot.create(:user, :lecturer)
        @course = FactoryBot.create(:course, creator: @lecturer)
        @lecture = FactoryBot.create(:lecture, lecturer: @lecturer, course: @course)
        @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload: @lecture, data: "Some Text")
        sign_in @student
      end

    it "can not be deleted by a student" do
        expect { post :destroy, params: { id: @lecturer_file[:id], lecture_id: @lecture.id, course_id: @course.id } }.to change(UploadedFile, :count).by(0)
      end

    it "can be deleted by the lecture owner" do
      sign_in @lecturer
      expect { post :destroy, params: { id: @lecturer_file[:id], lecture_id: @lecture.id, course_id: @course.id } }.to change(UploadedFile, :count).by(-1)
    end

    it "can't be deleted by someone else" do
      @other_lecturer = FactoryBot.create(:user, :lecturer)
      sign_in @other_lecturer
      expect { post :destroy, params: { id: @lecturer_file[:id], lecture_id: @lecture.id, course_id: @course.id } }.to_not change(UploadedFile, :count)
    end
  end
end
