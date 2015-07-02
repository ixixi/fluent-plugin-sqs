# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "fluent-plugin-sqs"
  s.version = "1.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yuri Odagiri"]
  s.date = "2015-05-26"
  s.email = "ixixizko@gmail.com"
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "AUTHORS",
    "Rakefile",
    "VERSION",
    "lib/fluent/plugin/in_sqs.rb",
    "lib/fluent/plugin/out_sqs.rb",
    "spec/lib/fluent/plugin/in_sqs_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "https://github.com/ixixi/fluent-plugin-sqs"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Amazon SQS input/output plugin for Fluent event collector"
  s.test_files = ["spec/lib/fluent/plugin/in_sqs_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fluentd>, ["~> 0.12.0"])
      s.add_runtime_dependency(%q<aws-sdk>, ["~> 1.9.5"])
      s.add_runtime_dependency(%q<yajl-ruby>, ["~> 1.0"])
    else
      s.add_dependency(%q<fluentd>, ["~> 0.12.0"])
      s.add_dependency(%q<aws-sdk>, ["~> 1.9.5"])
      s.add_dependency(%q<yajl-ruby>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<fluentd>, ["~> 0.12.0"])
    s.add_dependency(%q<aws-sdk>, ["~> 1.9.5"])
    s.add_dependency(%q<yajl-ruby>, ["~> 1.0"])
  end
  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rr"
  s.add_development_dependency "pry"
  s.add_development_dependency "jeweler"
  s.add_development_dependency "test-unit", ">= 3.0.0"
end
