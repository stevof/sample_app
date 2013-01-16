require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  after(:all)  { User.delete_all }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "new user should not have any microposts" do
      it { should have_content('0 microposts') }
    end

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end

    describe "micropost pluralization" do

      # test pluralization of "1 micropost" and "2 microposts"

      describe "singular" do
        before do
          fill_in 'micropost_content', with: "Bada bing"
          click_button "Post"
        end
        it { should have_selector('span#micropost_count', text: '1 micropost') }

        describe "plural" do
          before do
            fill_in 'micropost_content', with: "Ut sequi inventore"
            click_button "Post"
          end
          it { should have_selector('span#micropost_count', text: '2 microposts') }
        end
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "pagination" do

    before(:all) { 30.times { FactoryGirl.create(:micropost, user: user) } }
    after(:all)  { user.microposts.delete_all }

    it { should have_selector('div.pagination') }

    it "should list each micropost" do
      user.microposts.paginate(page: 1, per_page: 10).each do |micropost|
        page.should have_selector('li', text: micropost.content)
      end
    end

    it "should not have more than 10 microposts on the first page" do
      user.microposts.paginate(page: 2, per_page: 10).each do |micropost|
        page.should_not have_selector('li', text: micropost.content)
      end
    end
  end
end