def tests_setup(machine, options = {})

  machine.bindfs.debug = true

  machine.bindfs.bind_folder "/etc", "/etc-binded-symbol", options.merge({ chown_ignore: true })
  machine.bindfs.bind_folder "/etc", "/etc-binded-string", options.merge({ "chown-ignore" => true })

  machine.bindfs.bind_folder "/etc", "/etc-binded-with-option", options.merge({ owner: "root" })
  machine.bindfs.bind_folder "/etc", "/etc-binded-with-flag", options.merge({ "create-as-user" => true })
  machine.bindfs.bind_folder "/etc", "/etc-binded-with-short-option", options.merge({ r: true })
  machine.bindfs.bind_folder "/etc", "/etc-binded-without-explicit-owner", options.merge({ owner: nil })

  # This should fail
  machine.bindfs.bind_folder "/etc3", "/etc-nonexit", options

  # These should also fail
  machine.bindfs.bind_folder "/etc", "/etc-binded-with-nonexistent-user", options.merge({ user: "nonuser", after: :provision })
  machine.bindfs.bind_folder "/etc", "/etc-binded-with-nonexistent-group", options.merge({ group: "nongroup", after: :provision })

end
