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

If you run any rake task and you got an error:
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
if defined? Webdrivers
  # if you have latest chrome for which webdriver is not yet builded, ie greater
  # then https://chromedriver.storage.googleapis.com/LATEST_RELEASE
  # than put this line in .bashrc since old driver will probably work fine
  # export CHROMEDRIVER_VERSION="114.0.5735.90"
  Webdrivers::Chromedriver.required_version = ENV["CHROMEDRIVER_VERSION"]
end
~~~
