### Setup

Clone down the repository.

```
git clone git@github.com:getschomp/email_scraper.git
```

With ruby version manager and ruby 2.1.5 installed, run:

```
rvm use 2.1.5
```

Install external libraries with bundler.

```
bundle install
```

Install external dependency phantomjs, if you have homebrew just do:

```
brew install phantomjs
```

### Run
cd into the main project directory. Run a ruby file with the desired domain name appended.

```
ruby lib/find_email_addresses.rb <desired domain>
```

For example,

```
ruby lib/find_email_addresses.rb jana.com
```

To run the tests
```
rspec spec
```

### Disclaimer
This might not parse every web address out there in the wild, but I found the context surrounding the link to be the most meaningful way of ensuring that what seems link a link is one.
