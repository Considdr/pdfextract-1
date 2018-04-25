# Gem spec for pdf-extract-pg.
Gem::Specification.new do |s|
  s.name = "pdf-extract-pg"
  s.version = "0.0.0"
  s.summary = "PDF content extraction tool and library that works with pg rather than sqlite."
  s.files = Dir.glob("{bin,lib,data}/**/*")
  s.executables << "pdf-extract-pg"
  s.authors = ["Noah Finberg"]
  s.email = ["noah@considdr.com"]
  s.homepage = "http://github.com/Considdr/pdfextract"
  s.required_ruby_version = ">=1.9.1"

  s.add_dependency 'pdf-reader', '= 1.3.3'
  s.add_dependency 'nokogiri', '>= 1.5.0'
  s.add_dependency 'prawn', '>= 0.11.1'
  s.add_dependency 'pg', '>= 0.21.0'
  s.add_dependency 'commander', '>= 4.0.4'
  s.add_dependency 'json', '>= 1.5.1'
  s.add_dependency 'rb-libsvm', '>= 1.1.3'

  s.add_development_dependency 'mongo', '>= 1.9.2'
  s.add_development_dependency 'bson_ext', '>= 1.9.2'
  s.add_development_dependency 'rake', '>= 10.1.0'
end

