# vagrant-bindfs

A Vagrant plugin to automate [bindfs](http://bindfs.org/) mount in the VM. This allow you to change
owner, group and permissions on files and, for example, work around NFS share permissions issues.


## Some Background: Why `vagrant-bindfs`

The default vagrant provider is [virtualbox](https://www.virtualbox.org/).
It's free, and it works well, but it has some [performance problems](http://snippets.aktagon.com/snippets/609-Slow-IO-performance-with-Vagrant-and-VirtualBox-).

People often recommend switching to [vagrant's VMWare-fusion provider](http://www.vagrantup.com/vmware).
This reportedly has better performance, but shares with symlinks [won't work](http://communities.vmware.com/thread/428199?start=0&tstart=0).
You also have to buy both the plugin and VMWare-fusion.

The final recommendation, at least on Linux/OSX hosts, is to [use nfs](http://docs.vagrantup.com/v2/synced-folders/nfs.html).
However, an NFS mount has the same numeric permissions in the guest as in the host.
If you're on OSX, for instance, a folder owned by the default OSX user will appear to be [owned by `501:20`](https://groups.google.com/forum/?fromgroups#!topic/vagrant-up/qXXJ-AQuKQM) in the guest.

This is where `vagrant-bindfs` comes in!

Simply:

- mount your share over NFS into a temporary location in the guest
- re-mount the share to the actual destination with `vagrant-bindfs`, setting the correct permissions

_Note that `map_uid` and `map_gid` NFS options can be used to set the identity used to read/write files on the host side._

## Installation

Vagrant-bindfs is distributed as a Ruby gem. You can install it as any other Vagrant plugin
with `vagrant plugin install vagrant-bindfs`.


## Usage

In your `Vagrantfile`, use `config.bindfs.bind_folder` to configure folders that will be binded on VM
startup. The format is:

```ruby
config.bindfs.bind_folder "/path/to/source", "/path/to/destination", options
```


### Example

```ruby
Vagrant::Config.run do |config|

  [...] # Your VM configuration

  ## Basic usage
  config.bindfs.bind_folder "source/dir", "mount/point"

  ## Advanced options
  config.bindfs.bind_folder "source/dir", "mount/point",
  	perms: "u=rw:g=r:o=r",
  	create_as_user: true

  ## Complete example for a NFS shared folder

  # Declare shared folder with Vagrant syntax
  config.vm.synced_folder ".", "/vagrant-nfs", type: :nfs

  # Use vagrant-bindfs to re-mount folder
  config.bindfs.bind_folder "/vagrant-nfs", "/vagrant"

end
```


### Supported options

The `bind_folder` config supports the following long arguments, some of them are overwritable
with short options:

- `:force_user` (defaults to 'vagrant')
- `:force_group` (defaults to 'vagrant')
- `:perms` (defaults to 'u=rwX:g=rD:o=rD')
- `:mirror`
- `:mirror_only`
- `:map`
- `:create_for_user`
- `:create_for_group`
- `:create_with_perms`
- `:chmod_filter`
- `:read_rate`
- `:write_rate`

There are also options available for backward compatibility, if one of these options is defined
the newer counterpart will be unset:

- `:owner`
- `:group`

The following shortcuts are also available:

- `:o`
- `:u` (Overwrites the value of force_user)
- `:g` (Overwrites the value of force_group)
- `:m` (Overwrites the value of mirror)
- `:M` (Overwrites the value of mirror_only)
- `:p` (Overwrites the value of perms)

… and the following flags (all disabled by default, vagrant-bindfs rely on bindfs own defaults):

- `:create_as_user`
- `:create_as_mounter`
- `:chown_normal`
- `:chown_ignore`
- `:chown_deny`
- `:chgrp_normal`
- `:chgrp_ignore`
- `:chgrp_deny`
- `:chmod_normal`
- `:chmod_ignore`
- `:chmod_deny`
- `:chmod_allow_x`
- `:xattr_none`
- `:xattr_ro`
- `:xattr_rw`
- `:no_allow_other`
- `:realistic_permissions`
- `:ctime_from_mtime`
- `:hide_hard_links`
- `:multithreaded`

You can overwrite default options _via_ `config.bindfs.default_options`. See
[bindfs man page](http://bindfs.org/docs/bindfs.1.html) for details.

vagrant-bindfs does not check compatibility between given arguments but warn you when a binding
command fail or if bindfs is not installed on your virtual machine. On Debian and SUSE systems, it
will try to install bindfs automatically.


## Contributing

If you find this plugin useful, we could use a few enhancements! In particular, capabilities files
for installing vagrant-bindfs on systems other than Debian or SUSE would be useful. We could also
use some specs…


### How to Test Changes

If you've made changes to this plugin, you can easily test it locally in vagrant. From the root of
the repo, do:

- `bundle install`
- `rake build`
- `bundle exec vagrant up`

This will spin up a default Debian VM and try to bindfs-mount some shares in it. Feel free to modify
the included `Vagrantfile` to add additional test cases.
