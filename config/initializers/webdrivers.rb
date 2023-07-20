if defined? Webdrivers
  # if you have latest chrome for which webdriver is not yet builded, ie greater
  # then https://chromedriver.storage.googleapis.com/LATEST_RELEASE
  # than put this line in .bashrc since old driver will probably work fine
  # export CHROMEDRIVER_VERSION="114.0.5735.90"
  Webdrivers::Chromedriver.required_version = ENV["CHROMEDRIVER_VERSION"]
end
