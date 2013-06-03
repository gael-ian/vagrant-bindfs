# vagrant-bindfs

A Vagrant plugin to automate [bindfs](http://code.google.com/p/bindfs/) mount in the VM.
This allow you to change owner, group and permissions on files and, for example, work around NFS share permissions issues.


## Installation

Vagrant-bindfs is distributed as a Ruby gem.
You can install it as any other Vagrant plugin with `vagrant plugin install vagrant-bindfs`.


## Configure your VM

In your VagrantFile, you can use `config.bindfs.bind_folder` to configure folders that will be binded on VM startup.

    # In your Vagrantfile
    Vagrant::Config.run do |config|
    
      [...] # Your VM configuration

      # Basic usage
      config.bindfs.bind_folder "source/dir", "mount/point"
      
      # Advanced options
      config.bindfs.bind_folder "source/dir", "mount/point", :perms => "u=rw:g=r:o=r", :create_as_user => true
        
      # Complete example for a NFS shared folder
      config.vm.network :hostonly, "33.33.33.10" # (required to use NFS shared folder)
      config.vm.share_folder "nfs-share", "/vagrant-nfs", "host/source/dir", :nfs => true 
      config.bindfs.bind_folder "/vagrant-nfs", "guest/mount/point"
        
    end

bind_folder support following arguments...

- `:user` (defaults to 'vagrant')
- `:group` (defaults to 'vagrant')
- `:perms` (defaults to 'u=rwX:g=rD:o=rD')
- `:mirror`
- `:'mirror-only'`
- `:'create-for-user'`
- `:'create-for-group'`
- `:'create-with-perms'`

... and following flags (all disabled by default, vagrant-bindfs rely on bindfs own defaults) :

- `:'no-allow-other'`
- `:'create-as-user'`
- `:'create-as-mounter'`
- `:'chown-normal'`
- `:'chown-ignore'`
- `:'chown-deny'`
- `:'chgrp-normal'`
- `:'chgrp-ignore'`
- `:'chgrp-deny'`
- `:'chmod-normal'`
- `:'chmod-ignore'`
- `:'chmod-deny'`
- `:'chmod-allow-x'`
- `:'xattr-none'`
- `:'xattr-ro'`
- `:'xattr-rw'`
- `:'ctime-from-mtime'`
    
Ex: ``.

You can overwrite default options _via_ `config.bindfs.default_options`.

See [bindfs man page](http://www.cs.helsinki.fi/u/partel/bindfs_docs/bindfs.1.html) for details.

vagrant-bindfs does not check compatibility between given arguments but warn you when a binding command fail or if bindfs is not installed on your virtual machine.
On Debian systems, it will try to install bindfs automatically.
