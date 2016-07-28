# -*- encoding: utf-8 -*-
# stub: rpush 2.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rpush"
  s.version = "2.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ian Leitch"]
  s.date = "2016-02-09"
  s.description = "The push notification service for Ruby."
  s.email = ["port001@gmail.com"]
  s.executables = ["rpush"]
  s.files = ["bin/rpush"]
  s.homepage = "https://github.com/rpush/rpush"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "The push notification service for Ruby."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_runtime_dependency(%q<net-http-persistent>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, ["< 2.0", ">= 0.18.1"])
      s.add_runtime_dependency(%q<railties>, [">= 0"])
      s.add_runtime_dependency(%q<ansi>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, ["~> 1.0"])
      s.add_dependency(%q<net-http-persistent>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<thor>, ["< 2.0", ">= 0.18.1"])
      s.add_dependency(%q<railties>, [">= 0"])
      s.add_dependency(%q<ansi>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, ["~> 1.0"])
    s.add_dependency(%q<net-http-persistent>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<thor>, ["< 2.0", ">= 0.18.1"])
    s.add_dependency(%q<railties>, [">= 0"])
    s.add_dependency(%q<ansi>, [">= 0"])
  end
end
