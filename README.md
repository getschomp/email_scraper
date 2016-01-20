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

### Run

Run a ruby file with the desired domain name appended.

```
ruby email_addresses.rb <desired domain>
```

For example,

```
ruby email_addresses.rb www.tumblr.com
```
