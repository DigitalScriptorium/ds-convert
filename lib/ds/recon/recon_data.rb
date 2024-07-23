require 'git'
require 'logger'

module Recon
  module ReconData
    def self.update!
      repo_name = Settings.recon.git_local_name
      url       = Settings.recon.git_repo
      branch    = Settings.recon.git_branch || 'main'
      logger    = DS.logger

      Dir.chdir local_dir do
        unless File.exist? repo_name
          puts Git.clone url, repo_name, branch: branch, remote: 'origin', log: logger
        end
        g = Git.open repo_name, log: logger
        begin
          puts g.fetch 'origin'
          puts g.checkout branch
          puts g.pull 'origin', branch
        rescue Git::GitExecuteError => e
          logger.warn { "Error executing git command" }
          logger.warn { e.message }
          STDERR.puts e.backtrace if ENV['DS_VERBOSE']
        end
      end
    end

    def self.local_dir
      Settings.recon.local_dir
    end
    def self.repo_dir
      File.join DS.root, Settings.recon.git_local_name
    end

  end
end
