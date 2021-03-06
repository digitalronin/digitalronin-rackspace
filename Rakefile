require "rubygems"
require "rubygems/package_task"
require "rdoc/task"

require "rspec"
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(--format documentation --colour)
end


task default: ["spec"]

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "digitalronin-rackspace"
  s.version           = "0.1.11"
  s.summary           = "Rackspace Cloud Servers and Block Storage Volumes"
  s.description       = "Create/Query/Destroy rackspace cloud VMs and attached (or not) block storage volumes"
  s.author            = "David Salgado"
  s.email             = "david@digitalronin.com"
  s.homepage          = "https://github.com/digitalronin/digitalronin-rackspace"
  s.licenses          = ['MIT']

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.md)
  s.rdoc_options      = %w(--main README.md)

  # Add any extra files to include in the gem
  s.files             = %w(Gemfile Gemfile.lock LICENSE README.md) + Dir.glob("{spec,lib}/**/*")
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  s.add_dependency("fog", "~> 1.30")

  # If your tests use any gems, include them here
  s.add_development_dependency("rspec", "~> 3.2")
  s.add_development_dependency("pry-byebug", "~> 3.1")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# If you don't want to generate the .gemspec file, just remove this line. Reasons
# why you might want to generate a gemspec:
#  - using bundler with a git source
#  - building the gem without rake (i.e. gem build blah.gemspec)
#  - maybe others?
task package: :gemspec

# Generate documentation
RDoc::Task.new do |rd|
  rd.main = "README.txt"
  rd.rdoc_files.include("README.md", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task clean: [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end

task rebuild: [:clean, :package] do
  system "rm -rf ~/admoda/conductor/pkg"
  system "cp -r pkg ~/admoda/conductor/"
  system "cp digitalronin-rackspace.gemspec `find ~/admoda/conductor/pkg/ -type d -depth 1`"
end

task push: [:clean, :package] do
  system "gem push pkg/*.gem"
end
