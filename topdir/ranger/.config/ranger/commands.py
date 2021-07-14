# -*- coding: utf-8 -*-
# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import *
from ranger.api import *

import os.path


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

    Opens the specified path in vim
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

    def tab(self, tabnum):
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

class fzf_select(Command):
    """
    :fzf_select

    Find a path using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


import os
import signal
def zranger_chdir_handler(signal, frame):
    tmpfile = "/tmp/zranger-cwd-{}".format(os.getuid())
    with open(tmpfile, "r") as f:
        Command.fm.cd(f.readline().strip())
        os.unlink(tmpfile)
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

class copy_content(Command):
    """
    :copy_content

    Copies to clipboard either a path's contents or the directory tree (as an ascii-art).
    """
    def execute(self):
        import subprocess
        import os
        path = self.fm.thisfile.path
        if self.fm.thisfile.is_directory:
            tree = subprocess.Popen(["tree", "--", path], stdout=subprocess.PIPE)
            xclip = subprocess.Popen(["xclip"], stdin=tree.stdout)
            xclip.communicate()
        else:
            with open(path, 'r') as f:
                xclip = subprocess.Popen(["xclip"], stdin=f)
                xclip.communicate()

@register_linemode
class TreeLinemode(LinemodeBase):
    name = "tree"

    def filetitle(self, path, metadata):
        return "  " * path.relative_path.count("/", 0) + path.basename


from ranger.core.linemode import DefaultLinemode

@register_linemode
class SymlinkLinemode(DefaultLinemode):
    name = "symlink"

    def filetitle(self, path, metadata):
        if path.is_link:
            return "{} -> {}".format(path.relative_path, path.infostring)
        else:
            return super().filetitle(path, metadata)


class selfdebug(Command):
    def execute(self):
        import pdb
        from subprocess import check_output
        from sys import stdout
        term_reset_string = check_output(["reset"], universal_newlines=True)
        stdout.write(term_reset_string)
        pdb.set_trace()
        self.fm.exit()
