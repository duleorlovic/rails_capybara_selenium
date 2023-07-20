require 'rails_helper'

RSpec.describe "Articles", type: :system do
  it "see articles page" do
    visit articles_path
    expect(page.body).to include  "Articles"
  end
end
