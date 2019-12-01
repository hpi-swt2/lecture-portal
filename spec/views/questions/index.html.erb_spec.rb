require 'rails_helper'
# include Capybara::DSL

RSpec.describe "questions/index", type: :view do
  before(:each) do
    # assign(:questions, [
    #   Question.create!(
    #     :author => "MyText",
    #     :content => "MyText"
    #   ),
    #   Question.create!(
    #     :author => "MyText1",
    #     :content => "MyText1"
    #   )
    # ])
    @question = FactoryBot.create(:question)
  end

  it "has a question form if the user is a student" do
    @student = FactoryBot.create(:user, :student)
    sign_in @student
    visit questions_path
    expect(page).to have_field("questions[content]")
  end
  
  it "has no question form if the user is a lecturer" do
    @lecturer = FactoryBot.create(:user, :lecturer)
    sign_in @lecturer
    visit questions_path
    expect(page).not_to have_field("questions[content]")
  end

  it "has a big font if the user is a lecturer" do
    @lecturer = FactoryBot.create(:user, :lecturer)
    sign_in @lecturer
    visit questions_path
  end

  it "renders a list of questions" do
    visit questions_path
    expect(page).to have_content(@question.content)
  end

  it "renders a question after it has been submitted" do
    @student = FactoryBot.create(:user, :student)
    sign_in @student
    visit questions_path
    fill_in "content", :with => "MyQuestion"
    click_button("Submit")
    expect(page).to have_content("MyQuestion")
  end
end
