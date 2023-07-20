# https://github.com/duleorlovic/rails_capybara_selenium/blob/main/spec/support/capybara_selenium.rb
RSpec.configure do |config|
  config.before :each, type: :system do
    if ENV["USE_HEADFULL_CHROME"].present?
      # Use chrome only on local machine since CI will fail
      # export USE_HEADFULL_CHROME=true
      # rails test:system
      # unset USE_HEADFULL_CHROME
      driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
    else
      # driven_by :selenium_chrome_headless
      driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    end
  end
end
