require "rails_helper"

describe "The show lecture page", type: :feature do
  before(:each) do
    @lecture = FactoryBot.create(:lecture)
  end

  it "should have no end button if the lecture is not running" do
        visit(lecture_path(@lecture))
        expect(page).not_to have_selector("input[type=submit][value='End']")
      end


  it "should have an end button if the lecture is running" do
        @lecture.update(status: "running")
        visit(lecture_path(@lecture))
        expect(page).to have_selector("input[type=submit][value='End']")
      end

  it "should end the lecture if the end button is clicked" do
      @lecture.update(status: "running")
      visit(lecture_path(@lecture))
      click_on("End")
      @lecture.reload
      expect(@lecture.status).to eq("ended")
    end
end
