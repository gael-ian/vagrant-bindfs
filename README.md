# vagrant-bindfs

A Vagrant plugin to automate [bindfs](http://bindfs.org/) mount in the VM. This allow you to change owner, group and permissions on files and, for example, work around NFS share permissions issues.


## Some Background: Why `vagrant-bindfs`

The default vagrant provider is [virtualbox](https://www.virtualbox.org/).
It's free, and it works well, but it has some [performance problems](http://snippets.aktagon.com/snippets/609-Slow-IO-performance-with-Vagrant-and-VirtualBox-).

People often recommend switching to [vagrant's VMWare-fusion provider](http://www.vagrantup.com/vmware).
This reportedly has better performance, but shares with symlinks [won't work](http://communities.vmware.com/thread/428199?start=0&tstart=0).
You also have to buy both the plugin and VMware Fusion.

The final recommendation, at least on Linux/OSX hosts, is to [use NFS](http://docs.vagrantup.com/v2/synced-folders/nfs.html).
However, an NFS mount has the same numeric permissions in the guest as in the host.
If you're on OSX, for instance, a folder owned by the default OSX user will appear to be [owned by `501:20`](https://groups.google.com/forum/?fromgroups#!topic/vagrant-up/qXXJ-AQuKQM) in the guest.

This is where `vagrant-bindfs` comes in!

Simply:

- mount your share over NFS into a temporary location in the guest
- re-mount the share to the actual destination with `vagrant-bindfs`, setting the correct permissions

_Note that `map_uid` and `map_gid` NFS options can be used to set the identity used to read/write files on the host side._


## Installation

vagrant-bindfs is distributed as a Ruby gem. 
You can install it as any other Vagrant plugin with:

```bash
vagrant plugin install vagrant-bindfs
```


## Usage

In your `Vagrantfile`, use `config.bindfs.bind_folder` to configure folders that will be binded on VM startup.
The format is:

```ruby
config.bindfs.bind_folder "/path/to/source", "/path/to/destination", options
```

By default, all folders are binded after folders syncing between host and guest machines.
You can pass a special `:after` option to the bind_folder method to choose when a folder should be binded.
Supported values are :

* `:synced_folders` (default)
* `:provision`, to bind a folder after provisioning occured.

### Example

```ruby
Vagrant.configure("2") do |config|

  [...] # Your VM configuration

  ## Basic usage
  config.bindfs.bind_folder "source/dir", "mount/point"


  ## Advanced options
  config.bindfs.bind_folder "source/dir", "mount/point",
    perms: "u=rw:g=r:o=r", # http://bindfs.org/docs/bindfs.1.html#sect12
    create_as_user: true


  ## Complete example for a NFS shared folder

  # Static IP is required to use NFS shared folder,
  # this is only required for Virtualbox provider
  config.vm.network "private_network", ip: "192.168.50.4"

  # Declare shared folder with Vagrant syntax
  config.vm.synced_folder "host/source/dir", "/vagrant-nfs", type: :nfs

  # Use vagrant-bindfs to re-mount folder
  config.bindfs.bind_folder "/vagrant-nfs", "guest/mount/point"

  # Bind a folder after provisioning
  config.bindfs.bind_folder "/vagrant-after-provision", "another/guest/mount/point", after: :provision

end
```

Remember that Vagrant use `/vagrant` on guest side as a shared directory dedicated to provisioning and configuration. Binding a folder to `/vagrant` or one of its subfolders will fail.

### bindfs support

The `bind_folder` config accept any option you can pass to bindfs.
vagrant-bindfs is compatible with bindfs from version 1.9 to 1.13.4.
Check [lib/vagrant-bindfs/command.rb](https://github.com/gael-ian/vagrant-bindfs/blob/master/lib/vagrant-bindfs/command.rb#L66) for a complete list of supported options and default values and read the [bindfs man page](http://bindfs.org/docs/bindfs.1.html) for full documentation.

Both long arguments and shorthand are supported.
If you set both, shorthand will prevail.
Long arguments can be written indifferently with underscore ('force_user') or dash ('force-user') and as strings (:'force-user') or symbols (:force_user).

Option arguments values can be anything that can be casted to a string _via_ `to_s`.
The plugin will try to detect flag arguments values as true or false from common notations.  

vagrant-bindfs detects installed version of bindfs, translate option names when needed and ignore an option if it is not supported.
As we may have missed something, it will warn you when a binding command fail.

On Debian (this includes Ubuntu), SUSE, Fedora, CentOS (5-6), Gentoo and OS X guest systems, vagrant-bindfs will try to install bindfs automatically if it is not installed.
On other system, you'll get warned.

OS X guests may need some specific options. See [bindfs README](https://github.com/mpartel/bindfs#os-x-note) for details.

## Configuration

This plugin supports the following configuration options

### `debug`

Setting `config.bindfs.debug` to true will increase the verbosity level of this plugin in Vagrant output.

### `default_options`

You can overwrite default bindfs options _via_ `config.bindfs.default_options=`.

```ruby
Vagrant.configure("2") do |config|

  # These values are the default options 
  config.bindfs.default_options = {
    force_user:   'vagrant',
    force_group:  'vagrant',
    perms:        'u=rwX:g=rD:o=rD'
  }

end
```

### `skip_validations`

By default, `vagrant-bindfs` will check if the user and the group set for a binded folder exist on the virtual machine.
If either one, the other or both of them are missing, it will warn you and not execute any bindfs command for this folder.

To skip these validations, you can add `:user`and/or `:group` to the `config.bindfs.skip_validations` array.


```ruby
Vagrant.configure("2") do |config|
  
  config.bindfs.skip_validations << :user
  
end
```

### `bindfs_version` and `install_bindfs_from_source`

By default, if `bindfs` needs to be installed on the virtual machine, `vagrant-bindfs` will install the most recent release available in repositories (_via_ `homebrew` for OS X guests).
If no version of `bindfs` is found, it will try to install the most recent supported version of `bindfs` from source. (See [lib/vagrant-bindfs/bindfs.rb](https://github.com/gael-ian/vagrant-bindfs/blob/master/lib/vagrant-bindfs/bindfs.rb#L4) for the exact version number).

You can force the plugin to install the version of `bindfs` of your choice with the `bindfs_version` configuration option.
It will then look for the specified version in repositories and install it if available. If not, it will install it from sources.

You can also force installation from sources with the `install_bindfs_from_source` configuration option.
This will skip any repositories look up.

```ruby
Vagrant.configure("2") do |config|
  
  # This will force the plugin to install bindfs-1.12.2 from sources
  config.bindfs.bindfs_version = "1.12.2"
  config.bindfs.install_bindfs_from_source = true
  
end
```

**This feature only works with exact version match and does not try to resolve dependencies.**
In particular, Fuse will always be installed from the latest version available in repositories (_via_ Homebrew Cask for OS X guests).

### `force_empty_mountpoints`

By default, `vagrant-bindfs` won't try to empty an existing mount point before mount. Hence, if you try to bind a folder to a non-empty directory without explicitly allowing Fuse to do so (with the `nonempty` Fuse option), mount will fail.

You can ask `vagrant-bindfs` to make sure the mount points are empty with the `config.bindfs.force_empty_mountpoints` option.
Mount poitns will then be destroyed (with `rm -rf`) prior to mount, unless you allow Fuse to not mind (with the `nonempty` Fuse option).


```ruby
Vagrant.configure("2") do |config|
  
  config.bindfs.force_empty_mountpoint = true
  
  # This exemple assume two directories exist in your VM:
  # - `a/non/empty/mount/point/and/its/content`
  # - `another/non/empty/mount/point/and/its/content` 
  
  # `a/non/empty/mount/point` will be destroyed before mount and
  #  all its content will be lost.
  config.bindfs.bind_folder "/vagrant", "a/non/empty/mount/point"
  
  # `a/non/empty/mount/point` will not be destroyed before mount
  # but its content will not be accessible while in use by bindfs.
  config.bindfs.bind_folder "/vagrant", "a/non/empty/mount/point", o: :nonempty
  
end
```

## Contributing

If you find this plugin useful, we could use a few enhancements!
In particular, capabilities files for installing vagrant-bindfs on other systems would be useful.
We could also use some more specs…


### How to Test Changes

If you've made changes to this plugin, you can easily test it locally in vagrant.

Edit `Vagrantfile` and uncomment one or more of the selected test boxes.
Then, from the root of the repo, do:

    bundle install
    bundle exec vagrant up

This will spin up one or more VM and try to bindfs-mount some shares in it.
Feel free to modify the included `Vagrantfile` or test helpers (in `test/test_helpers.rb`) to add additional boxes and test cases.
