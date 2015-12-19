source "https://rubygems.org"

# fog depends on nokogiri, but the version bundled with fog has a security vulnerability,
# so this forces a safe version
gem "nokogiri", ">= 1.6.7.1"

gem "fog"

group :development do
  gem "rake"
  gem "pry-byebug"
  gem "rspec"
  gem "gem-this"
end
