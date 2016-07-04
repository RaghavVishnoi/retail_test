# -*- encoding: utf-8 -*-
# stub: colorbox-rails 0.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "colorbox-rails"
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["B\u{142}a\u{17c}ej Kosmowski", "Bart\u{142}omiej Danek", "Alexander Maslov", "Torsten Trautwein"]
  s.date = "2014-05-21"
  s.description = "Simple engine making colorbox use in rails super easy"
  s.email = ["b.kosmowski@selleo.com"]
  s.homepage = "http://www.selleo.com"
  s.rubygems_version = "2.2.2"
  s.summary = "Simple engine making colorbox use in rails super easy"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.1.1"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.1.1"])
      s.add_dependency(%q<jquery-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.1.1"])
    s.add_dependency(%q<jquery-rails>, [">= 0"])
  end
end
