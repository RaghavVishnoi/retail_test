# -*- encoding: utf-8 -*-
# stub: in_columns 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "in_columns"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jakob Skjerning"]
  s.date = "2013-08-16"
  s.description = "InColumns distributes the elements of an array into a number of equal-height columns."
  s.email = ["jakob@mentalized.net"]
  s.homepage = "https://github.com/koppen/in_columns"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Distributes array elements into columns."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
