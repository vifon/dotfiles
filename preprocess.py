#!/usr/bin/env python

from __future__ import print_function

import argparse
from jinja2 import Template
import os
import subprocess


def gather_facts():
    """The function gathering the facts available in the templates.

    """
    return {
        'tmux_version': get_tmux_version(),
        'env': os.environ,
    }


def get_tmux_version():
    return tuple(
        map(int,
            subprocess
            .check_output(["tmux", "-V"])
            .partition(" ")[2]
            .strip()
            .split(".")))


def render_file(template_path, facts):
    with open(template_path, 'r') as template_fh:
        template = Template(template_fh.read(),
                            trim_blocks=True)
    return template.render(**facts)


def main(argv=None):
    facts = gather_facts()

    parser = argparse.ArgumentParser()
    parser.add_argument('template_path')
    parser.add_argument('--list-facts', action='store_true')
    args = parser.parse_args()

    if args.list_facts:
        print(facts)
    else:
        print(render_file(args.template_path, facts))

if __name__ == '__main__':
    from sys import argv
    main(argv)
