require "rails_helper"

describe "The show lecture page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  describe "as a lecturer" do
  before(:each) do
    @lecturer = FactoryBot.create(:user, :lecturer)
    @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
    @course = @lecture.course
    sign_in @lecturer
  end

  it "should not be accesible by another lecturer" do
    @lecture2 = FactoryBot.create(:lecture)
    visit(course_lecture_path(course_id: @lecture2.course.id, id: @lecture2.id))
    expect(page).to_not have_current_path(course_lecture_path(course_id: @lecture2.course.id, id: @lecture2))
  end

  it "should download a course file when clicking on it" do
    @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
    visit(course_path(@course))
    click_on @lecturer_file.filename
    expect(page.body).to eql @lecturer_file.data
    expect(page.response_headers["Content-Type"]).to eql @lecturer_file.content_type
  end

  it "should have delete links for every file" do
      @student = FactoryBot.create(:user, :student)
      @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload: @lecture, data: "Something")
      visit(course_lecture_path(@course, @lecture))
      @delete_link_lecturer_file =find_link("Delete File", href: course_lecture_uploaded_file_path(@course, @lecture, @lecturer_file))
      expect { @delete_link_lecturer_file.click }.to change(UploadedFile, :count).by(-1)
    end

  it "should have download links for every file" do
      @student = FactoryBot.create(:user, :student)
      @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload: @lecture, data: "Something")
      visit(course_lecture_path(@course, @lecture))
      expect(page).to have_link(@lecturer_file.filename, href: course_lecture_uploaded_file_path(@course, @lecture, @lecturer_file))
    end

  it "should redirect to lecture page on link click" do
    @student = FactoryBot.create(:user, :student)
    @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload: @lecture, data: "Something")
    visit(course_lecture_path(@course, @lecture))
    @delete_link_lecturer_file =find_link("Delete File", href: course_lecture_uploaded_file_path(@course, @lecture, @lecturer_file))
    @delete_link_lecturer_file.click
    expect(current_path).to eq(course_lecture_path(@course, @lecture))
  end
end

  describe "as a student" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @student = FactoryBot.create(:user, :student)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer)
      sign_in @student
    end

    it "students should be able to leave a lecture" do
      @lecture.update(status: "running")
      @lecture.join_lecture(@student)
      visit(course_lecture_path(@lecture.course, @lecture))
      expect(@lecture.participating_students.length).to be 1
      expect(@lecture.participating_students[0]).to eq @student
      @lecture.reload
      click_on("Leave Lecture")
      @lecture.reload
      expect(@lecture.participating_students.length).to be 0
    end
  end
end
