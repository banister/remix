dlext = Config::CONFIG['DLEXT']
direc = File.dirname(__FILE__)

require 'rake/clean'
require 'rake/gempackagetask'
require "#{direc}/lib/remix/version"


CLEAN.include("ext/**/*.#{dlext}", "ext/**/*.log", "ext/**/*.o", "ext/**/*~", "ext/**/*#*", "ext/**/*.obj", "ext/**/*.def", "ext/**/*.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o")

def apply_spec_defaults(s)
  s.name = "remix"
  s.summary = "Ruby modules re-mixed and remastered"
  s.version = Remix::VERSION
  s.date = Time.now.strftime '%Y-%m-%d'
  s.author = "John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.description = s.summary
  s.require_path = 'lib'
  s.homepage = "http://banisterfiend.wordpress.com"
  s.has_rdoc = 'yard'
  s.files = FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c", "lib/**/*.rb",
                     "test/*.rb", "CHANGELOG", "README.markdown", "Rakefile"].to_a
end

task :test do
  sh "bacon -k #{direc}/test/test.rb"
end

[:mingw32, :mswin32].each do |v|
  namespace v do
    spec = Gem::Specification.new do |s|
      apply_spec_defaults(s)        
      s.platform = "i386-#{v}"
      s.files += FileList["lib/**/*.#{dlext}"].to_a
    end

    Rake::GemPackageTask.new(spec) do |pkg|
      pkg.need_zip = false
      pkg.need_tar = false
    end
  end
end

namespace :ruby do
  spec = Gem::Specification.new do |s|
    apply_spec_defaults(s)        
    s.platform = Gem::Platform::RUBY
    s.extensions = ["ext/remix/extconf.rb"]
  end
  
  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end
end

desc "build all platform gems at once"
task :gems => [:rmgems, "mingw32:gem", "mswin32:gem", "ruby:gem"]

desc "remove all platform gems"
task :rmgems => ["ruby:clobber_package"]

desc "build and push latest gems"
task :pushgems => :gems do
  chdir("#{direc}/pkg") do
    Dir["*.gem"].each do |gemfile|
      sh "gem push #{gemfile}"
    end
  end
end

  

