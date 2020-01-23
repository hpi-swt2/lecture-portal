require "rails_helper"

describe "The course detail page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "being signed in as a lecturer that created a lecture" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @course = FactoryBot.create(:course, creator: @lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer, course: @course)
      sign_in @lecturer
    end

    it "should have a \"Start\" button for not started lectures" do
      visit(course_path(@course))
      expect(page).to have_link("Start", href: start_lecture_path(course_id: @lecture.course.id) + "?id=" + @lecture.id.to_s)
    end

    it "should not have a \"View\" link for not started lectures" do
      visit(course_path(@course))
      expect(page).to_not have_link("View", href: course_lecture_path(@course, @lecture))
    end

    it "should have a \"Create Lecture\" button" do
      visit(course_path(@course))
      expect(page).to have_link("Create Lecture")
    end

    it "should set the lecture active on clicking \"Start\"" do
      visit(course_path(@course))
      click_on("Start")
      @lecture.reload
      expect(@lecture.status).to eq("running")
    end

    it "should redirect to the show path after clicking \"Start\"" do
      visit(course_path(@course))
      click_on("Start")
      expect(current_path).to eq(course_lecture_path(@course, @lecture))
    end

    it "should not show the \"Start\" button after a lecture was started" do
      visit(course_path(@course))
      click_on("Start")
      expect(page).not_to have_link("Start")
    end

    it "should show a \"View\" link after the lecture is started" do
      @lecture.update(status: "running")
      visit(course_path(@course))
      expect(page).to have_link("View", href: course_lecture_path(@course, @lecture))
    end

    it "should not show lectures of other lecturers" do
      course2 = FactoryBot.create(:course)
      lecture2 = FactoryBot.create(:lecture, course: course2)
      lecture2.update(status: "running")
      visit(course_path(@course))
      expect(page).to_not have_link("View", href: course_lecture_path(course2, lecture2))
    end

    it "should have an \"edit\" button." do
      visit course_path(@course)
      expect(page).to have_link("Edit", href: edit_course_lecture_path(course_id: @course.id, id: @lecture.id))
    end

    it "should redirect to current course page when accessed by a student" do
      @student = FactoryBot.create(:user, :student)
      @course.join_course(@student)
      sign_in @student
      visit(course_lecture_path(course_id: @course.id, id: @lecture.id))
      expect(page).to have_current_path(course_path(@course))
    end

    it "should show a file that was uploaded to the course by a lecturer" do
      @file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      expect(page).to have_link(@file.filename, href: uploaded_file_path(@file))
    end

    it "should show a file that was uploaded to the course by a student" do
      @student = FactoryBot.create(:user, :student)
      @file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      expect(page).to have_link(@file.filename, href: uploaded_file_path(@file))
    end

    it "should not show a file that is not linked to the course" do
      @other_course = FactoryBot.create(:course, creator: @lecturer)
      @file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @other_course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      expect(page).not_to have_link(@file.filename, href: uploaded_file_path(@file))
    end

    it "should show student and lecturer files in according tabs" do
     @student = FactoryBot.create(:user, :student)
     @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
     @student_file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
     visit(course_path(@course))
     expect(page).to have_xpath(".//div[@id='files-course']//ul//li//div//a[@href='#{uploaded_file_path(@lecturer_file)}']")
     expect(page).to_not have_xpath(".//div[@id='files-course']//ul//li//div//a[@href='#{uploaded_file_path(@student_file)}']")
     expect(page).to have_xpath(".//div[@id='files-students']//ul//li//div//a[@href='#{uploaded_file_path(@student_file)}']")
     expect(page).to_not have_xpath(".//div[@id='files-students']//ul//li//div//a[@href='#{uploaded_file_path(@lecturer_file)}']")
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
     @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
     @student_file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
     visit(course_path(@course))
     @delete_link_student_file = find_link("Delete File", href: uploaded_file_path(@student_file))
     @delete_link_lecturer_file =find_link("Delete File", href: uploaded_file_path(@lecturer_file))
     expect { @delete_link_student_file.click }.to change(UploadedFile, :count).by(-1)
     expect { @delete_link_lecturer_file.click }.to change(UploadedFile, :count).by(-1)
   end
  end

  context "being signed in as a student" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @course = FactoryBot.create(:course, creator: @lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer, course: @course)
      @student = FactoryBot.create(:user, :student)
      @course.join_course(@student)
      sign_in @student
    end

    it "should only have delete links for his own files" do
      @other_student = FactoryBot.create(:user, :student)
      @other_student_file = FactoryBot.create(:uploaded_file, author: @other_student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      @student_file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      expect(page).to have_selector("a[href='#{uploaded_file_path(@student_file)}'][data-method='delete']")
      expect(page).to_not have_selector("a[href='#{uploaded_file_path(@lecturer_file)}'][data-method='delete']")
      expect(page).to_not have_selector("a[href='#{uploaded_file_path(@other_student_file)}'][data-method='delete']")
      @delete_link = find_link("Delete File", href: uploaded_file_path(@student_file))
      expect { @delete_link.click }.to change(UploadedFile, :count).by(-1)
    end
  end
end
