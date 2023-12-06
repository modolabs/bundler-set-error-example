# bundle-docker

I have been having trouble with a docker setup that was failing due to a mismatch in the `set` gem.
The issue on github is here:
https://github.com/rubygems/rubygems/issues/7178

The intention of this repo is to provide a small test case that will demonstrate the problem
I am having.

These commands will result in an error:
```
docker build --no-cache --build-arg BUNDLE_WITHOUT=nil . -t test-project
docker run -t test-project bundle exec rails runner '1+1'
```

The error I am getting looks like this:
```
/app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/runtime.rb:304:in `check_for_activated_spec!': You have already activated set 1.0.1, but your Gemfile requires set 1.0.3. Since set is a default gem, you can either remove your dependency on it or try updating to a newer version of bundler that supports set as a default gem. (Gem::LoadError)
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/runtime.rb:25:in `block in setup'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/spec_set.rb:165:in `each'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/spec_set.rb:165:in `each'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/runtime.rb:24:in `map'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/runtime.rb:24:in `setup'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler.rb:162:in `setup'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/setup.rb:10:in `block in <top (required)>'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/ui/shell.rb:159:in `with_level'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/ui/shell.rb:111:in `silence'
  from /app/vendor/bundle/gems/bundler-2.4.22/lib/bundler/setup.rb:10:in `<top (required)>'
  from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
  from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/commands.rb:33:in `<module:Spring>'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/commands.rb:4:in `<top (required)>'
  from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
  from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/application.rb:87:in `preload'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/application.rb:157:in `serve'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/application.rb:145:in `block in run'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/application.rb:139:in `loop'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/application.rb:139:in `run'
  from /app/vendor/bundle/ruby/3.0.0/gems/spring-2.1.1/lib/spring/application/boot.rb:19:in `<top (required)>'
  from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
  from <internal:/usr/local/lib/ruby/3.0.0/rubygems/core_ext/kernel_require.rb>:85:in `require'
  from -e:1:in `<main>'
```
