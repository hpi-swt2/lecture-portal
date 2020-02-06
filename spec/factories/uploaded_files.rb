FactoryBot.define do
  factory :uploaded_file do
    content_type { "MyString" }
    filename { "Lord of the Files.file" }
    data { "Taking the data to Isengard" }
    isLink { false }
  end
end
