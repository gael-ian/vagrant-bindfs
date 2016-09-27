def tests_setup(machine)

  machine.bindfs.debug = true

  machine.bindfs.bind_folder "/etc",  "/etc-binded-symbol", chown_ignore: true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-string", "chown-ignore" => true

  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-option", owner: "root"
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-flag", "create-as-user" => true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-short-option", r: true
  machine.bindfs.bind_folder "/etc",  "/etc-binded-without-explicit-owner", owner: nil

  # This should fail
  machine.bindfs.bind_folder "/etc3", "/etc-nonexit"

  # These should also fail
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-nonexistent-user", user: "nonuser", after: :provision
  machine.bindfs.bind_folder "/etc",  "/etc-binded-with-nonexistent-group", group: "nongroup", after: :provision  

end
