module Bummr
  class Check
    include Singleton

    def check(fullcheck)
      @errors = []

      check_master
      check_log
      check_status

      if fullcheck == true
        check_diff
      end

      if @errors.any?
        if !yes? "Bummr found errors! Do you want to continue anyway?".red
          exit 0
        end
      else
        say "Ready to run bummr.".green
      end
    end

    def check_master
      if `git rev-parse --abbrev-ref HEAD` == "master\n"
        message = "Bummr is not meant to be run on master"
        say message.red
        say "Please checkout a branch with 'git checkout -b update-gems'"
        @errors.push message
      end
    end

    def check_log
      unless File.directory? "log"
        message = "There is no log directory or you are not in the root"
        say message.red
        @errors.push message
      end
    end

    def check_status
      status = `git status`

      if status.index 'are currently'
        message = ""

        if status.index 'rebasing'
          message += "You are already rebasing. "
        elsif status.index 'bisecting'
          message += "You are already bisecting. "
        end

        message += "Make sure `git status` is clean"
        say message.red
        @errors.push message
      end
    end

    def check_diff
      unless `git diff master`.empty?
        message = "Please make sure that `git diff master` returns empty"
        say message.red
        @errors.push message
      end
    end
  end
end
