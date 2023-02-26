# frozen_string_literal: true

describe VagrantBindfs::Vagrant::Plugin do
  describe '#synced_folder_hook' do
    subject(:plugin) { described_class }

    it 'can detect the middleware used by Vagrant for synced folders' do
      expect(plugin.synced_folders_hook).to be Vagrant::Action::Builtin::SyncedFolders
    end

    # See https://github.com/gael-ian/vagrant-bindfs/issues/91
    it 'does not mismatch synced folders middlewares with constants' do
      NFS = true # rubocop:disable RSpec/LeakyConstantDeclaration, Lint/ConstantDefinitionInBlock
      expect(plugin.synced_folders_hook).to be Vagrant::Action::Builtin::SyncedFolders
    end
  end
end
