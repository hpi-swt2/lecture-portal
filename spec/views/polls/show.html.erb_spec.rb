require "rails_helper"
require "capybara_table/rspec"

RSpec.describe "polls/show", type: :view do
  before(:each) do
    login_lecturer
    @lecture = FactoryBot.create(:lecture)
    @poll = FactoryBot.create(:poll)
    @poll_options = assign(:poll_options, [
      PollOption.create!(
        description: "abc",
        poll_id: @poll.id,
        votes: 2
      ),
      PollOption.create!(
        description: "def",
        poll_id: @poll.id,
        votes: 3
      )
     ])
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/false/)
  end

  it "shows votes for an inactive poll" do
    @poll.is_active = false
    @poll.save!
    visit course_lecture_poll_path(@lecture.course, @lecture, @poll)
    within "table" do
       expect(page).to have_text("Votes")
     end
  end

  it "does not show votes for an active poll" do
    @poll.is_active = true
    @poll.save!
    visit course_lecture_poll_path(@lecture.course, @lecture, @poll)
    within "table" do
      expect(page).to have_no_text("Votes")
    end
  end

  it "displays description, corresponding vote count and percentage for each poll option" do
    @poll.is_active = false
    @poll.save
    visit course_lecture_poll_path(@lecture.course, @lecture, @poll)
    expect(find(:table_row, { "Description" => "abc", "Votes" => "2", "Percentage" => "0.4" }, {}))
    expect(find(:table_row, { "Description" => "def", "Votes" => "3", "Percentage" => "0.6" }, {}))
  end

  it "counts the number of total participants correctly" do
    @poll.is_active = false
    @poll.save
    @answers = assign(:answers, [
      Answer.create!(
        poll_id: @poll.id,
         student_id: 1,
         option_id: @poll_options[0].id
      ),
      Answer.create!(
        poll_id: @poll.id,
         student_id: 1,
         option_id: @poll_options[1].id
      ),
      Answer.create!(
        poll_id: @poll.id,
         student_id: 2,
         option_id: @poll_options[0].id
      )
     ])

    visit course_lecture_poll_path(@lecture.course, @lecture, @poll)
    expect(page).to have_text("Participants: 2")
  end


  def login_lecturer
    user = FactoryBot.create(:user, :lecturer)
    sign_in(user, scope: :user)
  end
end
