# The Messy App
This is a ruby kata exploring coupling &amp; cohesion in a typical messy app.

## Getting Started
- If you don't use [asdf](https://asdf-vm.com/), ensure you have the right ruby installed (see [.tool-versions](.tool-versions)).
- If you don't use [direnv](https://direnv.net/), ensure you have all the environment variables set (see [.envrc](.envrc)).
1. Run `bundle install`
2. Run `rake db:create db:migrate`
3. Run `rspec`

Usage without variables is:
1. Run `export SCHEMA=db/schema.rb`
2. Run `bundle install`
3. Run `rake db:create db:migrate`
4. Run `rspec`

When in doubt do (or if you mess up the environment) use:
```
SCHEMA=db/schema.rb rake db:environment:set RAILS_ENV=development
SCHEMA=db/schema.rb rake db:drop db:create db:migrate
```
