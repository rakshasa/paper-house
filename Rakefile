# encoding: utf-8

require 'bundler/gem_tasks'

# rubocop:disable HashSyntax

task :default => :travis

task :travis => [:spec, :cucumber, :quality, 'coveralls:push']

desc 'Check for code quality'
task :quality => [:reek, :flog, :flay, :rubocop]

# rubocop:enable HashSyntax

Dir.glob('tasks/*.rake').each { |each| import each }
