# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'fluent-plugin-sqs'
  s.version = '2.1.2'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Yuri Odagiri']
  s.date = '2017-06-27'
  s.email = 'ixixizko@gmail.com'
  s.license = 'Apache-2.0'
  s.extra_rdoc_files = [
    'README.rdoc'
  ]
  s.files = [
    'AUTHORS',
    'Rakefile',
    'VERSION',
    'lib/fluent/plugin/in_sqs.rb',
    'lib/fluent/plugin/out_sqs.rb',
    'spec/lib/fluent/plugin/in_sqs_spec.rb',
    'spec/lib/fluent/plugin/out_sqs_spec.rb',
    'spec/spec_helper.rb'
  ]
  s.homepage = 'https://github.com/ixixi/fluent-plugin-sqs'
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.23'
  s.summary = 'Amazon SQS input/output plugin for Fluent event collector'
  s.test_files = ['spec/lib/fluent/plugin/in_sqs_spec.rb', 'spec/lib/fluent/plugin/out_sqs_spec.rb', 'spec/spec_helper.rb']

  if s.respond_to? :specification_version
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_runtime_dependency('fluentd', ['>= 0.12.0', '< 2'])
      s.add_runtime_dependency('aws-sdk-sqs', ['~> 1'])
      s.add_runtime_dependency('yajl-ruby', ['~> 1.0'])
    else
      s.add_dependency('fluentd', ['>= 0.12.0', '< 2'])
      s.add_dependency('aws-sdk-sqs', ['~> 1'])
      s.add_dependency('yajl-ruby', ['~> 1.0'])
    end
  else
    s.add_dependency('fluentd', ['>= 0.14.15', '< 2'])
    s.add_dependency('aws-sdk-sqs', ['~> 1'])
    s.add_dependency('yajl-ruby', ['~> 1.0'])
  end
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'jeweler'
  s.add_development_dependency 'test-unit', '>= 3.0.0'
end
