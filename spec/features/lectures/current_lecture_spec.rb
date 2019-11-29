require "rails_helper"

describe "The current lectures page", type: :feature do
  it "should only show active lectures" do
      @lectures = FactoryBot.create_list(:lecture, 2)
      @lectures[0].update(is_running: false)
      @lectures[1].update(is_running: true, name: "Other name")

      visit(current_lectures_path)
      expect(page).to_not have_css("td", text: @lectures[0].name)
      expect(page).to have_css("td", text: @lectures[1].name)
    end
end
