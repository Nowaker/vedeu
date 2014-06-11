module Vedeu
  class Launcher
    def initialize(argv, stdin = STDIN,
                         stdout = STDOUT,
                         stderr = STDERR,
                         kernel = Kernel)
      @argv      = argv
      @stdin     = stdin
      @stdout    = stdout
      @stderr    = stderr
      @kernel    = kernel
      @exit_code = 1
    end

    def execute!
      $stdin, $stdout, $stderr = @stdin, @stdout, @stderr

      Vedeu::Application.start

      @exit_code = 0
    ensure
      $stdin, $stdout, $stderr = STDIN, STDOUT, STDERR
      @kernel.exit(@exit_code)
    end
  end
end