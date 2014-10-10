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

Vagrant-bindfs is distributed as a Ruby gem.
You can install it as any other Vagrant plugin with `vagrant plugin install vagrant-bindfs`.


## Usage

In your `Vagrantfile`, use `config.bindfs.bind_folder` to configure folders that will be binded on VM startup.
The format is:

```ruby
config.bindfs.bind_folder "/path/to/source", "/path/to/destination", options
```


### Example

```ruby
Vagrant.configure("2") do |config|
  
  [...] # Your VM configuration
  
  ## Basic usage
  config.bindfs.bind_folder "source/dir", "mount/point"
  
  
  ## Advanced options
  config.bindfs.bind_folder "source/dir", "mount/point",
    perms: "u=rw:g=r:o=r",
    create_as_user: true
  
  
  ## Complete example for a NFS shared folder
  
  # Static IP is required to use NFS shared folder
  config.vm.network "private_network", ip: "192.168.50.4"
  
  # Declare shared folder with Vagrant syntax
  config.vm.synced_folder "host/source/dir", "/vagrant-nfs", :type => :nfs
  
  # Use vagrant-bindfs to re-mount folder
  config.bindfs.bind_folder "/vagrant-nfs", "guest/mount/point"
  
  
  ## Share the default `vagrant` folder via NFS with your own options
  config.vm.synced_folder ".", "/vagrant", type: :nfs
  config.bindfs.bind_folder "/vagrant", "/vagrant"

end
```


### Supported options

The `bind_folder` config accept any option you can pass to bindfs.
vagrant-bindfs is compatible with bindfs from version 1.9 to 1.12.6.
Check [lib/vagrant-bindfs/command.rb](https://github.com/gael-ian/vagrant-bindfs/blob/master/lib/vagrant-bindfs/command.rb#L66) for a complete list of supported options and default values.

Both long arguments and shorthand are supported.
If you set both, shorthand will prevail.
Long arguments can be written indifferently with underscore ('force_user') or dash ('force-user') and as strings (:'force-user') or symbols (:force_user).

You can overwrite default options _via_ `config.bindfs.default_options`.
See [bindfs man page](http://bindfs.org/docs/bindfs.1.html) for details.

vagrant-bindfs detects installed version of bindfs, translate option names when needed and ignore an option if it is not supported.
As we may have missed something, it will warn you when a binding command fail.

On Debian and SUSE guest systems, vagrant-bindfs will try to install bindfs automatically if it is not installed.
On other system, you'll get warned.


## Contributing

If you find this plugin useful, we could use a few enhancements!
In particular, capabilities files for installing vagrant-bindfs on systems other than Debian or SUSE would be useful.
We could also use some specs…


### How to Test Changes

If you've made changes to this plugin, you can easily test it locally in vagrant.
From the root of the repo, do:

- `bundle install`
- `rake build`
- `bundle exec vagrant up`

This will spin up a default Debian VM and try to bindfs-mount some shares in it.
Feel free to modify the included `Vagrantfile` to add additional test cases.
