require 'rsync/result'
require 'shellwords'

module Rsync
  # An rsync command to be run
  class Command
    # Runs the rsync job and returns the results
    #
    # @param args {Array}
    # @return {Result}
    def self.run(args, port = 0, ssh_key = '')
      running = [command, "--itemize-changes"]
      running += ['-e', "/usr/bin/ssh -o StrictHostKeyChecking=no -o \"NumberOfPasswordPrompts 0\" -p #{port}#{ ' -i "' + ssh_key + '"' if ssh_key != ''}"] if port.to_i > 0
      running += [args.flatten]
      output = run_command(running.flatten.shelljoin)
      Result.new(output, $?.exitstatus)
    end

    def self.command
      @command ||= 'rsync'
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
