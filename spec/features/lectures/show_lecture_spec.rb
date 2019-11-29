require "rails_helper"

describe "The show lecture page", type: :feature do
  it "should have no end button if the lecture is not running" do
      @lecture = FactoryBot.create(:lecture)
      @lecture.update(is_running: false)
      visit(lecture_path(@lecture))
      expect(page).not_to have_selector("input[type=submit][value='End']")
      end


  it "should have an end button if the lecture is running" do
      @lecture = FactoryBot.create(:lecture)
      visit(lecture_path(@lecture))
      expect(page).to have_selector("input[type=submit][value='End']")
      end

  it "should end the lecture if the end button is clicked" do
      @lecture = FactoryBot.create(:lecture)
      visit(lecture_path(@lecture))
      click_on("End")
      @lecture.reload
      expect(@lecture.is_running).to be(false)
    end
end
