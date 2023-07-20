# Capybara selenium

In Rails we use Capybara which uses Selenium to drive web browser. It needs
webdrivers which can be installed using gem https://github.com/titusfortner/webdrivers

```
gem 'webdrivers'
```
and running task

```
RAILS_ENV=test rails webdrivers:chromedriver:update
```
this will detect your chrome and install appropriate webdriver binary to
`~/.webdrivers/chromedriver`


## Chrome version

If you run browser test (eg `rails test:system`) and you got an error:
```
Webdrivers::VersionError: Unable to find latest point release version for 115.0.5790. You appear to be using a non-production version of Chrome. Please set `Webdrivers::Chromedriver.required_version = <desired driver version>` to a known chromedriver version: https://chromedriver.storage.googleapis.com/index.html


Caused by:
Webdrivers::NetworkError: Net::HTTPClientException: 404 "Not Found" with https://chromedriver.storage.googleapis.com/LATEST_RELEASE_115.0.5790
```

It means you are using very recent version of chrome (in this error it is
version "115.0.5790") which is not yet supported.
So you can hardcode to latest supported version
https://chromedriver.storage.googleapis.com/LATEST_RELEASE for example
"114.0.5735.90" so it does not autodetect based on your local chrome (99% that
old driver will work with latest chrome)
~~~
# config/initializers/webdrivers.rb
# https://github.com/duleorlovic/rails_capybara_selenium/blob/main/config/initializers/webdrivers.rb
if defined? Webdrivers
  # When you have latest chrome for which webdriver is not yet builded, ie
  # greater then https://chromedriver.storage.googleapis.com/LATEST_RELEASE
  # than put this line in .bashrc since old driver will probably work fine
  # export CHROMEDRIVER_VERSION="114.0.5735.90"
  Webdrivers::Chromedriver.required_version = ENV["CHROMEDRIVER_VERSION"]
end
~~~

## CI

When you run test on CI you need to run in headless_chrome

```
# test/application_system_test_case.rb
  # https://github.com/duleorlovic/rails_capybara_selenium/blob/main/test/application_system_test_case.rb
  if ENV["USE_HEADFULL_CHROME"].present?
    # Use chrome only on local machine since CI will fail
    # export USE_HEADFULL_CHROME=true
    # rails test:system
    # unset USE_HEADFULL_CHROME
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  else
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
```

and if you want to run locally
```
USE_HEADFULL_CHROME=true rails test:system
```

For Rspec you need to configure inside `spec` folder so after installing rspec

```
bundle add rspec-rails --group "development, test"
rails generate rspec:install
git add . && git commit -m'rails generate rspec:install'
```

you can configure

```
# spec/support/capybara_selenium.rb
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
```
so you can run sample system test in headless mode
```
# spect/system/articles_spec.rb
require 'rails_helper'

RSpec.describe "Articles", type: :system do
  it "see articles page" do
    visit articles_path
    expect(page.body).to include  "Articles"
  end
end
```

with
```
rspec spec/system/articles_spec.rb
USE_HEADFULL_CHROME=true rspec spec/system/articles_spec.rb
```
