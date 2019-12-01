require "rails_helper"

# RSpec.describe "questions/index", type: :view do
#   context "with user signed in as student" do
#     before(:each) do
#       @student = FactoryBot.create(:user, :student)
#       sign_in(@student, scope: :user)
#     end

#     it "has a question form" do
#       render
#       puts page.find_by_id("#questionInput").id
#       expect(page).to have_field("questionInput")
#     end
#     it "renders a list of questions" do
#       question = FactoryBot.create(:question, :author => @student)
#       visit questions_path
#       expect(page).to have_content(question.content)
#     end
#     it "renders a question after it has been submitted" do
#       visit questions_path
#       fill_in "questionInput", :with => "Question"
#       click_button("Submit")
#       expect(page).to have_content("Question")
#     end
#   end

#   context "with user signed in as lecturer" do
#     before(:each) do
#       @lecturer = FactoryBot.create(:user, :lecturer)
#       sign_in(@lecturer, scope: :user)
#     end

#     it "has no question form" do
#       visit questions_path
#       expect(page).not_to have_field("questions[content]")
#     end
#     it "has a big font" do
#       visit questions_path
#       # TODO: test
#     end
#   end
# end
