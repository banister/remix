$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), '..')

require 'rake/clean'
require 'rake/gempackagetask'

require 'lib/remix/version'

$dlext = Config::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{$dlext}", "ext/**/*.log", "ext/**/*.o", "ext/**/*~", "ext/**/*#*", "ext/**/*.obj", "ext/**/*.def", "ext/**/*.pdb")
CLOBBER.include("**/*.#{$dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o")

specification = Gem::Specification.new do |s|
  s.name = "remix"
  s.summary = "Ruby modules re-mixed and remastered"
  s.version = Remix::VERSION
  s.date = Time.now.strftime '%Y-%m-%d'
  s.author = "John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.description = s.summary
  s.require_path = 'lib'
  #s.platform = Gem::Platform::RUBY
  s.platform = 'i386-mswin32'
  s.homepage = "http://banisterfiend.wordpress.com"
  s.has_rdoc = 'yard'

  #s.extensions = ["ext/remix/extconf.rb"]
  s.files =  ["Rakefile", "README.markdown", "CHANGELOG", 
              "lib/remix.rb", "lib/remix/version.rb"] +
    ["lib/1.9/remix.so", "lib/1.8/remix.so"] +
  FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c"].to_a 
end

Rake::GemPackageTask.new(specification) do |package|
  package.need_zip = false
  package.need_tar = false
end
