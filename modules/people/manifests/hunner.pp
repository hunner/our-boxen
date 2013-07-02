class people::hunner {
  File {
    owner => $::luser,
    group => 'staff',
  }

  $homedir     = "/Users/${::luser}"
  $preferences = "${homedir}/Library/Preferences"

  file { [
    "${homedir}/local",
    "${homedir}/local/bin",
    "${homedir}/Documents/work",
    "${homedir}/Documents/work/git",
  ]:
    ensure => directory,
    owner  => $::luser,
    group  => 'staff',
  }

  repository { "${homedir}/Documents/work/git/git-tools":
    source => 'adrienthebo/git-tools',
  }
  file { "${homedir}/local/bin/git-merged":
    ensure => link,
    target => "${homedir}/Documents/work/git/git-tools/git-merged",
  }

  ## boxen apps
  include alfred
  include chrome::dev
  include crashplan
  include dropbox
  include flux
  include googledrive
  include hipchat
  include iterm2::dev
  include macvim
  include minecraft
  include onepassword
  include ruby::global
  include skype
  include slate
  include tmux
  include tunnelblick
  include virtualbox

  osx::recovery_message { 'If this Mac is found, please call 1-877-575-9775': }
  include osx::dock::clear_dock
  include osx::dock::autohide
  include osx::universal_access::ctrl_mod_zoom
  include osx::no_network_dsstores
  include osx::finder::show_all_on_desktop
  class { 'osx::global::key_repeat_delay':
    delay => 0,
  }
  class { 'osx::global::key_repeat_rate':
    rate => 0,
  }
  class { 'osx::dock::icon_size': 
    size => 32,
  }

  ## homebrew packages
  package { [
    'htop-osx',
    'pianobar',
    'reattach-to-user-namespace',
    'wget',
    'zsh',
  ]:
    ensure => present,
  }

  ## Set up user environment
  file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
  }
  -> osx_chsh { $::luser:
    shell   => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
  }

  #TODO
  #- set wallpaper to grey
  #- create 9 spaces
  #- set up spaces keyboard shortcuts
  #- increase key repeat rate
  #- bind caps -> ctrl
  #- bring in dotfiles
  #- set up droxbox?
  #- set up google drive?
  #- set up iterm to point to dropbox?

  # Disable Gatekeeper so you can install any package you want
  property_list_key { 'Disable Gatekeeper':
    ensure => present,
    path   => '/var/db/SystemPolicy-prefs.plist',
    key    => 'enabled',
    value  => 'no',
  }

  property_list_key { 'Disable lion fullscreen in macvim':
    ensure     => present,
    path       => "${preferences}/com.apple.MacVim.plist",
    key        => 'MMNativeFullScreen',
    value      => false,
    value_type => 'boolean',
    before     => File['macvim plist'],
  }
  file { 'macvim plist':
    ensure  => file,
    path    => "${preferences}/com.apple.MacVim.plist",
    mode    => '0600',
  }

  # Uncheck 4 spaces checkboxes
  property_list_key { 'Don\'t group apps':
    ensure     => present,
    path       => "${preferences}/com.apple.dock.plist",
    key        => 'expose-group-by-app',
    value      => false,
    value_type => 'boolean',
    notify     => Exec['Restart the Dock'],
    before     => File['dock plist'],
  }
  property_list_key { 'Disable dashboard':
    ensure     => present,
    path       => "${preferences}/com.apple.dock.plist",
    key        => 'mcx-disabled',
    value      => true,
    value_type => 'boolean',
    notify     => Exec['Restart the Dock'],
    before     => File['dock plist'],
  }
  property_list_key { 'Disable dashboard space':
    ensure     => present,
    path       => "${preferences}/com.apple.dock.plist",
    key        => 'dashboard-in-overlay',
    value      => true,
    value_type => 'boolean',
    notify     => Exec['Restart the Dock'],
    before     => File['dock plist'],
  }
  property_list_key { 'Don\'t sort spaces':
    ensure     => present,
    path       => "${preferences}/com.apple.dock.plist",
    key        => 'mru-spaces',
    value      => false,
    value_type => 'boolean',
    notify     => Exec['Restart the Dock'],
    before     => File['dock plist'],
  }

  #property_list_key { 'Faster animations':
  #  ensure     => present,
  #  path       => "${preferences}/com.apple.dock.plist",
  #  key        => 'expose-animation-duration',
  #  value      => '0.0',
  #  value_type => 'real',
  #  notify     => Exec['Restart the Dock'],
  #  before     => File['dock plist'],
  #}

  file { 'dock plist':
    ensure  => file,
    path    => "${preferences}/com.apple.dock.plist",
    mode    => '0600',
    notify  => Exec['Restart the Dock'],
  }
  exec { 'Restart the Dock':
    command     => '/usr/bin/killall -HUP Dock',
    refreshonly => true,
  }

  property_list_key { 'Tap to click':
    ensure     => present,
    path       => "${preferences}/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist",
    key        => 'Clicking',
    value      => true,
    value_type => 'boolean',
    before     => File['trackpad plist'],
  }
  property_list_key { '3-finger app expose':
    ensure     => present,
    path       => "${preferences}/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist",
    key        => 'TrackpadThreeFingerVertSwipeGesture',
    value      => '2',
    value_type => 'integer',
    before     => File['trackpad plist'],
  }
  property_list_key { '3-finger app expose 2':
    ensure     => present,
    path       => "${preferences}/com.apple.dock.plist",
    key        => 'showAppExposeGestureEnabled',
    value      => true,
    value_type => 'boolean',
    before     => File['dock plist'],
  }

  file { 'trackpad plist':
    ensure  => file,
    path    => "${preferences}/com.apple.driver.AppleBluetoothMultitouch.trackpad.plist",
    mode    => '0600',
  }

  property_list_key { 'Ctrl zoom':
    ensure     => present,
    path       => "${preferences}/com.apple.universalaccess.plist",
    key        => 'closeViewScrollWheelToggle',
    value      => true,
    value_type => 'boolean',
    before     => File['universalaccess plist'],
  }

  file { 'universalaccess plist':
    ensure  => file,
    path    => "${preferences}/com.apple.universalaccess.plist",
    mode    => '0600',
  }

  property_list_key { 'Disable keyboard light':
    ensure     => present,
    path       => "${preferences}/com.apple.BezelServices.plist",
    key        => 'kDim',
    value      => false,
    value_type => 'boolean',
    before     => File['bezel plist'],
  }

  property_list_key { 'Disable screen dimming':
    ensure     => present,
    path       => "${preferences}/com.apple.BezelServices.plist",
    key        => 'dAuto',
    value      => false,
    value_type => 'boolean',
    before     => File['bezel plist'],
  }

  file { 'bezel plist':
    ensure  => file,
    path    => "${preferences}/com.apple.BezelServices.plist",
    mode    => '0600',
  }
}
