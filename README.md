## vagrant-bindfs

A Vagrant plugin to automate [bindfs](http://code.google.com/p/bindfs/) mount in the VM.
This allow you to change owner, group and permissions on files and, for example, work around NFS share permissions issues.

### Configure your VM

In your VagrantFile, you can use `config.bindfs.bind_folder` to configure folders that will be binded on VM startup.  
Its basic syntax is `config.bindfs.bind_folder "source/dir", "mount/point"`.

Additionnaly, you can provide one of the following arguments :

- `:user` (defaults to 'vagrant')
- `:group` (defaults to 'vagrant')
- `:perms` (defaults to 'u=rwD:g=rD:o=rD')
- `:mirror`
- `:mirror_only`
- `:no_allow_other`
- `:create_for_user`
- `:create_for_group`
- `:create_with_perms`

Ex: `config.bindfs.bind_folder "source/dir", "mount/point", :perms => "u=rw:g=r:o=r"`.

See [bindfs man page](http://www.cs.helsinki.fi/u/partel/bindfs_docs/bindfs.1.html) for details.

### TODO

-   bindfs installation check
-   Support all bindfs options   
    Unsupported options:
    * :create-as-user
    * :create-as-mounter
    * :chown-normal
    * :chown-ignore
    * :chown-deny
    * :chgrp-normal
    * :chgrp-ignore
    * :chgrp-deny
    * :chmod-normal
    * :chmod-ignore
    * :chmod-deny
    * :chmod-allow-x
    * :xattr-none
    * :xattr-ro
    * :xattr-rw
    * :ctime-from-mtime
-   Write unit tests

