# -*- coding: utf-8 -*-
# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import *


class shell(Command):
    escape_macros_for_shell = True

    def execute(self):
        if self.arg(1) and self.arg(1)[0] == '-':
            flags = self.arg(1)[1:]
            command = self.rest(2)
        else:
            flags = ''
            command = self.rest(1)

        if not command and 'p' in flags:
            command = 'cat %f'
        if command:
            if '%' in command:
                command = self.fm.substitute_macros(command, escape=True)
            self.fm.execute_command(command, flags=flags)
            if command == "$SHELL":
                with open("/tmp/rangershelldir", "r") as f:
                    self.fm.cd(f.readline().strip())
                os.unlink("/tmp/rangershelldir")

    def tab(self):
        from ranger.ext.get_executables import get_executables
        if self.arg(1) and self.arg(1)[0] == '-':
            command = self.rest(2)
        else:
            command = self.rest(1)
        start = self.line[0:len(self.line) - len(command)]

        try:
            position_of_last_space = command.rindex(" ")
        except ValueError:
            return (start + program + ' ' for program \
                    in get_executables() if program.startswith(command))
        if position_of_last_space == len(command) - 1:
            selection = self.fm.thistab.get_selection()
            if len(selection) == 1:
                return self.line + selection[0].shell_escaped_basename + ' '
            else:
                return self.line + '%s '
        else:
            before_word, start_of_word = self.line.rsplit(' ', 1)
            return (before_word + ' ' + file.shell_escaped_basename \
                    for file in self.fm.thisdir.files \
                    if file.shell_escaped_basename.startswith(start_of_word))


class terminal(Command):
    """:terminal

    Spawns an "x-terminal-emulator" starting in the current directory.
    """
    def execute(self):
        import os
        from ranger.ext.get_executables import get_executables
        if os.environ.get('TMUX'):
            command = 'tmux split-window -h'
        else:
            command = os.environ.get('TERMCMD', os.environ.get('TERM'))
            if command not in get_executables():
                command = 'x-terminal-emulator'
            if command not in get_executables():
                command = 'xterm'
        self.fm.run(command, flags='f')


class edit(Command):
    """:edit <filename>

    Opens the specified file in vim
    """

    def execute(self):
        if not self.arg(1):
            filepath = self.fm.thisfile.path
        else:
            filepath = self.rest(1)
        if os.environ.get('TMUX'):
            self.fm.run("tmux split-window -h '$EDITOR {}'"
                        .format(filepath), flags='f')
        else:
            self.fm.edit_file(filepath)

    def tab(self):
        return self._tab_directory_content()


import subprocess
class fasd(Command):
    """
    :fasd

    Jump to directory using fasd
    """
    def execute(self):
        arg = self.rest(1)
        if arg:
            directory = subprocess.check_output(["fasd", "-d"]+arg.split(), universal_newlines=True).strip()
            self.fm.cd(directory)

class fzfcd(Command):
    def execute(self):
        command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
                 -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            directory = stdout.decode('utf-8').rstrip('\n')
            self.fm.cd(directory)


import signal
def zranger_chdir_handler(signal, frame):
    with open("/tmp/zranger-cwd", "r") as f:
        Command.fm.cd(f.readline().strip())
        os.unlink("/tmp/zranger-cwd")
signal.signal(signal.SIGUSR1, zranger_chdir_handler)

class tmux_detach(Command):
    """
    :tmux_detach

    Detach from this tmux session (if inside tmux).
    """
    def execute(self):
        if not os.environ.get('TMUX'):
            return
        os.system("tmux detach")


if 'chdir_hook' in globals():
    if os.environ.get('TERM').startswith('rxvt-unicode'):
        @chdir_hook
        def urxvt_cwd_spawn_hook(prev, new):
            from sys import stdout
            stdout.write("\033]777;cwd-spawn;path;{cwd}\007".format(cwd=new))
            stdout.flush()

class selfdebug(Command):
    def execute(self):
        import pdb
        from subprocess import check_output
        from sys import stdout
        term_reset_string = check_output(["reset"])
        stdout.write(term_reset_string)
        pdb.set_trace()
        self.fm.exit()
