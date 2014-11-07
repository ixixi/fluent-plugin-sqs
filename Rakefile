require 'rake'
require 'rake/testtask'
require 'rake/clean'
require "bundler/gem_tasks"

Rake::TestTask.new(:test) do |t|
  t.test_files = Dir['test/*_test.rb']
  t.ruby_opts = ['-rubygems'] if defined? Gem
  t.ruby_opts << '-I.'
end

task :default => [:build]
