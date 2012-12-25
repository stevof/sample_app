FactoryGirl.define do
  factory :user do
    name     "Steve Fisher"
    email    "stevof@yahoo.com"
    password "foobar"
    password_confirmation "foobar"
  end
end