# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Breaking changes

* Drop support for Ruby < 2.7

### Added

* Update bindfs support to 1.17.2

### Changed

* Introduce Github Actions to automate unit tests (#97)

## Version 1.1.9 (2021-09-21)

### Added

* Support for bindfs 1.15.1

## Version 1.1.8 (2020-09-04)

### Added

* Support for bindfs 1.14.7

## Version 1.1.7 (2020-04-08)

### Fixed

* `config.default_options` inconsistent uses through contexts (See #93)
* Detection of Vagrant's available synced folders hook (See #91)

## Version 1.1.6 (2020-01-14)

### Fixed

* Remove upper constraint on Ruby version (See #92)

## Version 1.1.5 (2019-12-23)

### Added

* Support for bindfs 1.14.2

### Fixed

* Documentation (#88 and #89, thanks to @cherouvim)

### Changed

* Update test boxes

## Version 1.1.4 (2019-06-21)

### Fixed

* bindfs installation from sources (See #87)

## Version 1.1.3 (2019-06-20)

### Fixed

* Silence bindfs source installation cleanup messages

## Version 1.1.2 (2019-06-18)

### Fixed

* Download of bindfs sources tarballs

## Version 1.1.1 (2019-06-07)

### Added

* Support for bindfs 1.14.0

### Fixed

* Installation documentation (#84, thanks to @ahmadmayahi)
* bindfs package detection on Red Hat and derivated (See #83)

### Changed

* Remove reserved destination path validations (#86, thanks to @bartoszj)
* Update test boxes
* Update Vagrant sources location to use `hashicorp/vagrant`
* Update documentation

## Version 1.1.0 (2018-01-30)

### Added

* `:force_empty_mountpoint` configuration option, for compatibility with Fuse's `nonempty` option

## Version 1.0.11 (2017-12-20)

### Added

* Support for Gentoo guests

### Changed

* Update tests boxes
* Extract capabilities to a JSON file

## Version 1.0.10 (2017-12-01)

### Added

* Support for bindfs 1.13.9

### Fixed

* Link to bindfs documentation (#75, thanks to @grahamrhay)

### Changed

* Argument formatting

## Version 1.0.9 (2017-09-04)

### Changed

* Update bindfs backup URL to download sources (#74, thanks to @mpartel)

## Version 1.0.8 (2017-06-30)

### Fixed

* Force repository update before package installation on Debian (See #72)

## Version 1.0.7 (2017-04-08)

### Added

* Support for bindfs 1.13.7

## Version 1.0.6 (2017-03-25)

### Fixed

* Accept `nil` as a value for string options (See #70)

## Version 1.0.5 (2017-02-22)

### Added

* More explicit error messages

## Version 1.0.4 (2017-02-07)

### Added

* Support for bindfs 1.13.6

## Version 1.0.3 (2017-01-01)

### Fixed

* bndfs full path detection (#67, thanks to @herebebogans)

## Version 1.0.2 (2016-12-16)

### Fixed

* Always use bindfs full path (See #64)
* Automatically cast arguments according to type (option or flag) (#63, thanks to @pdesgarets)

### Changed

* Improved bindfs installation process

## Version 1.0.1 (2016-12-05)

### Fixed

* Explicit requirements on Ruby's `Enumerable` and `Forwardable` modules
* Uninitialized constant `VagrantBindfs::Bindfs::OptionSet::Forwardable` (#62, thanks to @rpnzl)

## Version 1.0.0 (2016-12-04)

### Added

* Allow to specify version of bindfs to be installed (See #54)

### Changed

* Improved capabilities
* Distinguish configuration and runtime validations
* Distinguish Vagrant relate code and bindfs related code
* Introduce RuboCop
* Unit tests with RSpec

## Version 0.4.14 (2016-11-29)

### Fixed

* Uninitialized constant `Vagrant::Plugins::Bindfs::SOURCE_VERSION` (#61, thanks to @rbngzlv)

## Version 0.4.13 (2016-11-26)

### Fixed

* Ruby version requirements (#57, thanks to @renan)

## Version 0.4.12 (2016-11-18)

### Added

* `:source_version` configuration option, to control version of bindfs installed from source (See #54)
* Exclude `/vagrant` from allowed destination paths

### Fixed

* Downgrade Ruby requirements (See #55)

## Version 0.4.11 (2016-10-28)

### Added

* Support for bindfs 1.13.4 new options (See #52)

## Version 0.4.10 (2016-10-02)

### Added

* OS X support

### Changed

* Use bento boxes only for tests

## Version 0.4.9 (2016-07-04)

### Changed

* Support mirrors to download bindfs sources on source install (See #46)

## Version 0.4.8 (2016-07-01)

### Changed

* Download URL for bindfs sources on source install (See #46)

## Version 0.4.7 (2016-04-21)

### Fixed

* Overwriting user or group (See #41)
* bindfs version detection (#43, thanks to @msabramo)

### Changed

* Update tests configuration and boxes

## Version 0.4.6 (2015-11-30)

### Added

* Support for bindfs 1.13 new options

## Version 0.4.5 (2015-11-30)

### Fixed

* bindfs version detection

## Version 0.4.4 (2015-11-29)

### Added

* Support for bindfs 1.13
* Allow to skip user/group verifications (#36, thanks to @charliewolf)

### Fixed

* Improved error message (#34, thanks to @aronwoost)
* bindfs version detection

## Version 0.4.3 (2015-08-31)

### Fixed

* Detection of bound folders (See #33)

## Version 0.4.2 (2015-07-02)

### Added

* Allow folders to be bound after folders syncing or after provisioning
* Handle missing user/group (#32, thanks to @mhaylock)

## Version 0.4.1 (2015-06-17)

### Fixed

* Installation dependencies on Red Hat guests (#30, thanks to @kekkis)
* Link to bindfs documentation (#26, thanks to @aconrad)

## Version 0.4.0 (2015-02-02)

### Fixed

* Fuse detection on Ubuntu guests
* Installation dependencies on Red Hat guests
* Compatibility with older RHEL Server (#25, thanks to @jliebert)

## Version 0.3.4 (2015-01-17)

### Fixed

* Fuse kernel module loading (See #20)

## Version 0.3.3 (2015-01-17)

### Added

* CentOS 5 & 6 guests support (#24, thanks to @ricoli)

## Version 0.3.2 (2014-11-08)

### Added

* Fedora guests support
* Use `modprobe` to check Fuse is avalable and loaded (#17, thanks to @tboerger)

### Fixed

* Documentation (#16, thanks to @tboerger)

## Version 0.3.1 (2014-10-10)

### Fixed

* Compatibility with old Vagrantfiles (See #15)
* Documentation

## Version 0.3.0 (2014-10-08)

### Added

* Support for Vagrant capabilities (#14, thanks to @tboerger)

## Version 0.2.4 (2014-01-04)

### Added

* Basic support for fuse options

### Fixed

* Option short names support

## Version 0.2.3 (2013-12-16)

### Added

* Compatibility with Vagrant 1.4
* Improve documentation

### Changed

* Internal Ruby namespaces

## Version 0.2.2 (2013-07-22)

### Added

* Improve documentation

## Version 0.2.1 (2013-06-04)

### Fixed

* Hook precedence (#5, thanks to @igor47)

## Version 0.2.0 (2013-06-03)

### Breaking changes

* Rewrite to support Vagrant's new plugin API (#4, thanks to @igor47)

## Version 0.1.9 (2012-12-18)

### Fixed

* Prevent double execution of `bindfs` commands (#3, thanks to @juanje)
* I18n namespace for error messages (#1, thanks to @avit)

## Version 0.1.8 (2012-01-31)

### Breaking changes

* Drop support for Vagrant < 0.9.4

### Added

* Compatibility with Vagrant 0.9.4
* Documentation and license

## Version 0.1.7 (2011-02-08)

### Changed

* Remove unnecessary logging

## Version 0.1.6 (2011-02-08)

### Fixed

* Default permissions now compatible with executable files
* `no-allow-other` wrongly considered as an option

## Version 0.1.5 (2011-02-07)

### Fixed

* Injection into Vagrant's middleware stacks so `vagrant-bindfs` commands can be used as soon as a VM is created.

## Version 0.1.4 (2011-02-07)

### Fixed

* Compatibility with Vagrant 0.7

## Version 0.1.3 (2010-12-30)

### Added

* Check if bindfs is installed on guest machine
* Failed commands reporting

## Version 0.1.2 (2010-11-29)

### Added

* Support for bindfs flag options

## Version 0.1.1 (2010-11-22)

### Added

* Improve documentation

## Version 0.1.0 (2010-11-22)

* Initial release
