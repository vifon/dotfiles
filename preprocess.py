#!/usr/bin/env python

from __future__ import print_function

import argparse
from jinja2 import Template
import os
import subprocess
import sys


def cleanup(output_path, verbose=False):
    if os.path.exists(output_path):
        if verbose:
            print("Removing `{}'".format(output_path), file=sys.stderr)
        os.unlink(output_path)


def gather_facts():
    """The function gathering the facts available in the templates.

    """
    return {
        'tmux_version': get_tmux_version(),
    }


def get_tmux_version():
    return tuple(
        map(int,
            subprocess
            .check_output(["tmux", "-V"])
            .partition(" ")[2]
            .strip()
            .split(".")))


def load_template(template_path):
    """Load a Jinja template from a file.

    """
    with open(template_path, 'r') as template_fh:
        return Template(
            template_fh.read(),
            keep_trailing_newline=True,
        )


def render_template_to_file(template, output_path, facts, verbose=False):
    """Render a Jinja template to an output file.

    """
    if verbose:
        print("Generating `{}'".format(output_path), file=sys.stderr)
    facts.update(os.environ)  # Make the env vars available in the templates.
    if output_path is None:
        print(template.render(**facts), end="")
    else:
        template.stream(**facts).dump(output_path)


def main(argv=None):
    facts = gather_facts()

    parser = argparse.ArgumentParser()
    parser.add_argument('template_path', default=None, nargs='?')
    parser.add_argument('output_path', default=None, nargs='?')
    parser.add_argument('--list-facts', action='store_true')
    parser.add_argument('-v', '--verbose', action='store_true')
    parser.add_argument('--clean', action='store_true',
                        help="remove the generated files")
    args = parser.parse_args()

    if args.list_facts:
        print(facts, file=sys.stderr)

    if args.clean:
        cleanup(args.output_path, args.verbose)
    elif args.template_path:
        render_template_to_file(
            load_template(args.template_path),
            args.output_path,
            facts,
            verbose=args.verbose,
        )

if __name__ == '__main__':
    from sys import argv
    main(argv)
