require "rails_helper"

describe "The course detail page", type: :feature do
  # Include Devise helpers that allow usage of `sign_in`
  include Devise::Test::IntegrationHelpers

  context "being signed in as a lecturer that created a lecture" do
    before(:each) do
      @lecturer = FactoryBot.create(:user, :lecturer)
      @course = FactoryBot.create(:course, creator: @lecturer)
      @lecture = FactoryBot.create(:lecture, lecturer: @lecturer, course: @course)
      @student = FactoryBot.create(:user, :student)
      sign_in @lecturer
    end

    it "should not have a \"View\" link for not started lectures" do
      visit(course_path(@course))
      expect(page).to_not have_link("View", href: course_lecture_path(@course, @lecture))
    end

    it "should have a \"Create Lecture\" button" do
      visit(course_path(@course))
      expect(page).to have_link("Create Lecture")
    end
    it "should show a \"Review\" button when lecture is ended" do
      expect(@lecture.update(date: Date.yesterday)).to be_truthy
      visit(course_path(@course))
      expect(page).to have_link("Review", href: course_lecture_path(@course, @lecture))
    end

    it "should show a \"View\" link after the lecture is started" do
      @lecture.update(date: Date.today, start_time: DateTime.now, end_time: DateTime.now + 2.hours)
      visit(course_path(@course))
      expect(page).to have_link("View", href: course_lecture_path(@course, @lecture))
    end

    it "should show a \"View\" link when the lecture is active" do
      @lecture.update(date: Date.today, start_time: DateTime.now + 1.hours, end_time: DateTime.now + 2.hours)
      visit(course_path(@course))
      expect(page).to have_link("View", href: course_lecture_path(@course, @lecture))
    end

    it "should show a \"View\" link after the lecture is created" do
      @lecture.update(date: Date.tomorrow)
      visit(course_path(@course))
      expect(page).to have_link("View", href: course_lecture_path(course_id: @course.id, id: @lecture.id, anchor: "settings"))
    end

    it "should not show lectures of other lecturers" do
      course2 = FactoryBot.create(:course)
      lecture2 = FactoryBot.create(:lecture, course: course2)
      lecture2.update(date: Date.today, start_time: DateTime.now, end_time: DateTime.now + 2.hours)
      visit(course_path(@course))
      expect(page).to_not have_link("View", href: course_lecture_path(course2, lecture2))
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
      expect(page).to have_link(@file.filename, href: course_uploaded_file_path(@course, @file))
    end

    it "should show a file that was uploaded to the course by a student" do
      @student = FactoryBot.create(:user, :student)
      @file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      expect(page).to have_link(@file.filename, href: course_uploaded_file_path(@course, @file))
    end

    it "should not show a file that is not linked to the course" do
      @other_course = FactoryBot.create(:course, creator: @lecturer)
      @file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @other_course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      expect(page).not_to have_link(@file.filename, href: course_uploaded_file_path(@course, @file))
    end

    it "should show student and lecturer files in according tabs" do
     @student = FactoryBot.create(:user, :student)
     @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
     @student_file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
     visit(course_path(@course))
     expect(page).to have_xpath(".//div[@id='files-course']//ul//li//div//a[@href='#{course_uploaded_file_path(@course, @lecturer_file)}']")
     expect(page).to_not have_xpath(".//div[@id='files-course']//ul//li//div//a[@href='#{course_uploaded_file_path(@course, @student_file)}']")
     expect(page).to have_xpath(".//div[@id='files-students']//ul//li//div//a[@href='#{course_uploaded_file_path(@course, @student_file)}']")
     expect(page).to_not have_xpath(".//div[@id='files-students']//ul//li//div//a[@href='#{course_uploaded_file_path(@course, @lecturer_file)}']")
   end

    it "should download a course file when clicking on it" do
      @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      click_on @lecturer_file.filename
      expect(page.body).to eql @lecturer_file.data
      expect(page.response_headers["Content-Type"]).to eql @lecturer_file.content_type
    end

    it "should have delete links for every file" do
      @lecturer_file = FactoryBot.create(:uploaded_file, author: @lecturer, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      @student_file = FactoryBot.create(:uploaded_file, author: @student, allowsUpload_id: @course.id, allowsUpload_type: "Course", data: "Something")
      visit(course_path(@course))
      @delete_link_student_file = find_link("Delete File", href: course_uploaded_file_path(@course, @student_file))
      @delete_link_lecturer_file =find_link("Delete File", href: course_uploaded_file_path(@course, @lecturer_file))
      expect { @delete_link_student_file.click }.to change(UploadedFile, :count).by(-1)
      expect { @delete_link_lecturer_file.click }.to change(UploadedFile, :count).by(-1)
    end

    it "shoud have an \"Add Material\" link" do
        visit(course_path(@course))
        expect(page).to have_link("Add Material", href: new_course_uploaded_file_path(@course))
      end

    it "shoud have an \"Add Material\" link for students" do
      sign_in @student
      visit(course_path(@course))
      expect(page).to have_link("Add Material", href: new_course_uploaded_file_path(@course))
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
      expect(page).to have_selector("a[href='#{course_uploaded_file_path(@course, @student_file)}'][data-method='delete']")
      expect(page).to_not have_selector("a[href='#{course_uploaded_file_path(@course, @lecturer_file)}'][data-method='delete']")
      expect(page).to_not have_selector("a[href='#{course_uploaded_file_path(@course, @other_student_file)}'][data-method='delete']")
      @delete_link = find_link("Delete File", href: course_uploaded_file_path(@course, @student_file))
      expect { @delete_link.click }.to change(UploadedFile, :count).by(-1)
    end

    it "should show a \"Review\" button when lecture is ended for a student who joined the lecture" do
      @lecture.join_lecture(@student)
      expect(@lecture.update(date: Date.yesterday)).to be_truthy
      visit(course_path(@course))
      expect(page).to have_link("Review", href: course_lecture_path(@course, @lecture))
    end

    it "should show a \"Review\" button when lecture is ended for a student who did not join the lecture" do
      expect(@lecture.update(date: Date.yesterday)).to be_truthy
      visit(course_path(@course))
      expect(page).to have_link("Review", href: course_lecture_path(@course, @lecture))
    end
  end
end
