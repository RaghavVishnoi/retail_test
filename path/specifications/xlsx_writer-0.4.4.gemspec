# -*- encoding: utf-8 -*-
# stub: xlsx_writer 0.4.4 ruby lib

Gem::Specification.new do |s|
  s.name = "xlsx_writer"
  s.version = "0.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Dee Zsombor", "Justin Beck", "Seamus Abshere"]
  s.date = "2014-10-28"
  s.description = "Writes XLSX files. Minimal XML and style. Supports autofilters and headers/footers with images and page numbers."
  s.email = ["seamus@abshere.net"]
  s.homepage = "https://github.com/seamusabshere/xlsx_writer"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Writes XLSX files. Minimal XML and style. Supports autofilters and headers/footers with images and page numbers."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<fast_xs>, [">= 0"])
      s.add_runtime_dependency(%q<unix_utils>, [">= 0"])
      s.add_runtime_dependency(%q<murmurhash3>, [">= 0.1.4"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<minitest-reporters>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<remote_table>, [">= 0"])
      s.add_development_dependency(%q<ruby-decimal>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<fast_xs>, [">= 0"])
      s.add_dependency(%q<unix_utils>, [">= 0"])
      s.add_dependency(%q<murmurhash3>, [">= 0.1.4"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<minitest-reporters>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<remote_table>, [">= 0"])
      s.add_dependency(%q<ruby-decimal>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<fast_xs>, [">= 0"])
    s.add_dependency(%q<unix_utils>, [">= 0"])
    s.add_dependency(%q<murmurhash3>, [">= 0.1.4"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<minitest-reporters>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<remote_table>, [">= 0"])
    s.add_dependency(%q<ruby-decimal>, [">= 0"])
  end
end
