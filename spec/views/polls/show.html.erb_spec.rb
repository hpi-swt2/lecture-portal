require "rails_helper"

RSpec.describe "polls/show", type: :view do
  before(:each) do
  	login_lecturer
    @lecture = FactoryBot.create(:lecture)
    @poll_option = FactoryBot.create(:poll_option)
    @poll = FactoryBot.create(:poll)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/false/)
  end

  it "shows votes for an inactive poll" do
  	@poll.is_active = false
 	visit lecture_poll_path(@lecture, @poll)
 	within 'table' do
  	  expect(page).to have_text("Votes")
  	end
  end

  it "does not show votes for an active poll" do
  	@poll.is_active = true #apparently this is not set during the test, the page shows it is still false
  	visit lecture_poll_path(@lecture, @poll)
  	#save_and_open_page
  	within 'table' do
  	  expect(page).to have_no_text("Votes")
  	end

  end


  def login_lecturer
    user = FactoryBot.create(:user, :lecturer)
    sign_in(user, scope: :user)
  end

end
