## vagrant-bindfs

A Vagrant plugin to automate [bindfs](http://code.google.com/p/bindfs/) mount in the VM.
This allow you to change owner, group and permissions on files and, for example, work around NFS share permissions issues.

### Configure your VM

In your VagrantFile, you can use `config.bindfs.bind_folder` to configure folders that will be binded on VM startup.  
Its basic syntax is `config.bindfs.bind_folder "source/dir", "mount/point"`.

bind_folder support following arguments...

- `:user` (defaults to 'vagrant')
- `:group` (defaults to 'vagrant')
- `:perms` (defaults to 'u=rwD:g=rD:o=rD')
- `:mirror`
- `:mirror_only`
- `:no_allow_other`
- `:create_for_user`
- `:create_for_group`
- `:create_with_perms`

... and following flags (all disabled by default, vagrant-bindfs rely on bindfs own defaults) :

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
- `:ctime_from_mtime`
    
Ex: `config.bindfs.bind_folder "source/dir", "mount/point", :perms => "u=rw:g=r:o=r", :create_as_user => true`.

You can overwrite default options _via_ `config.bindfs.default_options`.

See [bindfs man page](http://www.cs.helsinki.fi/u/partel/bindfs_docs/bindfs.1.html) for details.

vagrant-bindfs does not check compatibility between given arguments!  
You can set both of `:chown_ignore` and `:chown_deny` to true without errors, until the mount command will be executed by Vagrant.

### TODO

-   bindfs installation check
-   Write unit tests
