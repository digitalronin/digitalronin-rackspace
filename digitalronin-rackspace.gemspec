# -*- encoding: utf-8 -*-
# stub: digitalronin-rackspace 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "digitalronin-rackspace"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Salgado"]
  s.date = "2015-05-11"
  s.description = "Create/Query/Destroy rackspace cloud VMs and attached (or not) block storage volumes"
  s.email = "david@digitalronin.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["Gemfile", "Gemfile.lock", "LICENSE", "README.md", "lib/rackspace.rb", "lib/rackspace/api.rb", "lib/rackspace/base.rb", "lib/rackspace/logger.rb", "lib/rackspace/server_api.rb", "lib/rackspace/storage_api.rb", "lib/rackspace/vm.rb", "lib/rackspace/volume.rb", "spec/rackspace/vm_spec.rb", "spec/rackspace/volume_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "https://github.com/digitalronin/digitalronin-rackspace"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.4.6"
  s.summary = "Rackspace Cloud Servers and Block Storage Volumes"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fog>, ["~> 1.30"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2"])
      s.add_development_dependency(%q<pry-byebug>, ["~> 3.1"])
    else
      s.add_dependency(%q<fog>, ["~> 1.30"])
      s.add_dependency(%q<rspec>, ["~> 3.2"])
      s.add_dependency(%q<pry-byebug>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<fog>, ["~> 1.30"])
    s.add_dependency(%q<rspec>, ["~> 3.2"])
    s.add_dependency(%q<pry-byebug>, ["~> 3.1"])
  end
end
