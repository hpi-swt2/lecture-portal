require "rails_helper"

describe "The all lectures page", type: :feature do
  before(:each) do
    @lecture = FactoryBot.create(:lecture)
  end

  it "should have a \"Start\" button for not started lecture" do
    # TODO: user has to be lecturer for this
    visit(lectures_path)
    expect(page).to have_selector("input[type=submit][value='Start']")
  end

  it "should not have a \"View\" link for not started lecture" do
    # TODO: user has to be lecturer for this
    visit(lectures_path)
    expect(page).to_not have_link("View", href: lecture_path(@lecture))
  end

  it "should have a \"Create Lecture\" button" do
    # TODO: user has to be lecturer for this
    visit(lectures_path)
    expect(page).to have_link("Create Lecture")
  end

  it "should set the lecture active on clicking \"Start\"" do
      # TODO: user has to be lecturer for this
      visit(lectures_path)
      click_on("Start")
      @lecture.reload
      expect(@lecture.status).to eq("running")
    end

  it "should redirect to the show path after clicking \"Start\"" do
    # TODO: user has to be lecturer for this
    visit(lectures_path)
    click_on("Start")
    expect(current_path).to eq(lecture_path(@lecture))
  end

  it "should not show the \"Start\" button after a lecture was started" do
    # TODO: user has to be lecturer for this
    visit(lectures_path)
    click_on("Start")
    expect(page).not_to have_selector("input[type=submit][value='Start']")
  end

  it "should show a \"View\" link after the lecture is started" do
    # TODO: user has to be lecturer for this
    @lecture.update(status: "running")
    visit(lectures_path)
    expect(page).to have_link("View", href: lecture_path(@lecture))
  end
end
