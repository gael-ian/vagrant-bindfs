# vagrant-bindfs

A Vagrant plugin to automate [bindfs](http://code.google.com/p/bindfs/) mount in the VM.
This allow you to change owner, group and permissions on files and, for example, work around NFS share permissions issues.

## Configure your VM

In your VagrantFile, you can use `config.bindfs.bind_folder` to configure folders that will be binded on VM startup. Its basic syntax is `config.bindfs.bind_folder "source/dir" "mount/point"`.

Additionnaly, you can provide one of the following arguments :

- `:user  => "name"` : Name of the owner of binded files
- `:group => "name"` : Name of the owner group of binded files
- `:perm  => "permissions-string"` : Permissions string as defined in the bindfs documentation

More options to come in further releases.

## TODO

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

== Copyright

Copyright (c) 2010 Folken Laëneck. See LICENSE.txt for further details.

