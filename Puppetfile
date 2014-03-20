# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.4.2"

# Support for default hiera data in modules

github "module-data", "0.0.3", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",     "1.0.1"
github "foreman",     "1.2.0"
github "gcc",         "2.0.100"
github "git",         "2.3.0"
github "go",          "1.1.0"
github "homebrew",    "1.6.2"
github "hub",         "1.3.0"
github "inifile",     "1.0.3", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",       "1.4.3"
github "nodejs",      "3.7.0"
github "openssl",     "1.0.0"
github "phantomjs",   "2.3.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.3.0"
github "ruby",        "7.3.0"
github "stdlib",      "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
github "xquartz",     "1.1.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

github "alfred",            "1.1.7"
github "chrome",            "1.1.2"
github "crashplan",         "1.0.1"
github "dropbox",           "1.2.0"
github "emacs",             "1.1.0"
github "googledrive",       "1.0.2"
#mod "gpgtools",             :git => 'git://github.com/hunner/puppet-gpgtools.git', :ref => 'use_2013-08-06'
github "hipchat",           "1.1.0"
github "iterm2",            "1.0.4"
#github "mactex",            "0.1.0", :repo => "Omegaice/puppet-mactex"
github "macvim",            "1.0.0"
github "minecraft",         "1.0.2"
github "mumble",            "1.0.5"
github "omnigraffle",       "1.3.0"
github "onepassword",       "1.1.0"
github "osx",               "2.2.2"
github "skype",             "1.0.8"
github "slate",             "1.0.0"
github "tmux",              "1.0.2"
github "tunnelblick",       "1.0.4"
github "vagrant",           "3.0.6"
github "virtualbox",        "1.0.10"
github "vlc",               "1.0.5"
github "vmware_fusion",     "1.1.0"
#github "flux",              "1.0.0"
#github "property_list_key", "0.2.0"
mod "property_list_key", :git => 'git://github.com/glarizza/puppet-property_list_key', :ref => "0.2.0"
