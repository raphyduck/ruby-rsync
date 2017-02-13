require 'rsync/result'
require 'shellwords'

module Rsync
  # An rsync command to be run
  class Command
    # Runs the rsync job and returns the results
    #
    # @param args {Array}
    # @return {Result}
    def self.run(*args)
      output = run_command([command, "--itemize-changes",
        '-e', '/usr/bin/ssh -o StrictHostKeyChecking=no -o "NumberOfPasswordPrompts 0"',
        args].flatten.shelljoin)
      Result.new(output, $?.exitstatus)
    end

    def self.command
      @command ||= "rsync -e 'ssh -o StrictHostKeyChecking=no -o \"NumberOfPasswordPrompts 0\"'"
    end

    def self.command=(cmd)
      @command = cmd
    end

private

    def self.run_command(cmd, &block)
      puts "Running: #{cmd}"
      if block_given?
        IO.popen("#{cmd} 2>&1", &block)
      else
        `#{cmd} 2>&1`
      end
    end
  end
end
