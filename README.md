# Nix Elm Tools

[![Build Status](https://travis-ci.org/turboMaCk/nix-elm-tools.svg?branch=master)](https://travis-ci.org/turboMaCk/nix-elm-tools)

[Elm](https://elm-lang.org/) lang community tooling
for the [Nix package manager](https://nixos.org/nix/) and [NixOS](http://nixos.org)
operating system.

## Motivation

Getting all the existing community tooling for Elm language running with nix is painful.
This is mostly due to the usage of [binary wrappers](https://github.com/avh4/binwrap) to make
haskell binaries and node.js work together. For instance `nodePackages.elm-test`
provided by [nixpkgs](https://github.com/NixOS/nixpkgs) as of today
isn't working. I believe situation can be improved though!
Generally there are two ways to do so:

1. Remove all the hacks in upstream packages to make them nix compatible out of the box.
2. Implement custom nix specific builds for elm tooling with nix specific patches.

Given that nix users makes only for a tiny fraction elm community I believe
it would be naive to try to enforce compatibility directly in upstream packages
and therefore this project uses 2nd approach to provide elm lang tooling to nix community.

## Rules

These are the rules followed:

1. [x] Builds on NixOS
2. [x] Builds are reasonably fast (eg. we avoid usage of stack2nix and large rebuilds of Haskell packages)
3. [x] Easy to pull from remote
4. [x] Nixpkgs like conventions
5. [x] Linux and MacOS portability
6. [x] Utilizing existing nix tooling

## Components

Tooling provided so far:

- [elm-test](https://github.com/rtfeldman/node-test-runner)
- [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples)
- [elm-analyse](https://github.com/stil4m/elm-analyse)
- [elm-doc-preview](https://github.com/dmy/elm-doc-preview)

If you miss your favorite tool, feel free to open an issue or submit a PR.

## Usage

nix-env from source:

```shell
# clone project
$ git clone https://github.com/turboMaCk/nix-elm-tools.git
$ cd nix-elm-tools

# install elm-test
$ nix-env -f default.nix -iA elm-test
installing 'node-elm-test-0.19.0-rev6'
building '/nix/store/bf69nj0mzfqajgip1bpxwg05y1zh7191-user-environment.drv'...
created 21 symlinks in user environment
```

remote install:

```nix
let
  pkgs = import <nixpkgs> {};

  elmTools = import (pkgs.fetchFromGitHub {
    owner = "turboMaCk";
    repo = "nix-elm-tools";
    rev = "b2c9d05796c85eeaf2424fc3ce7da4a16bb5ae48";
    sha256 = "1gzcvzpgcqb3bx162fxy299h8arkjhmv8gafl5ja6lnq9l5iqbzv";
  }) { inherit pkgs; };
in
{
  inherit (elmTools) elm-test elm-verify-examples;
}
```

nix-shell remote install:

```nix
{ pkgs ? import <nixpkgs> {} }:
let
  elmTools = import (pkgs.fetchFromGitHub {
    owner = "turboMaCk";
    repo = "nix-elm-tools";
    rev = "b2c9d05796c85eeaf2424fc3ce7da4a16bb5ae48";
    sha256 = "1gzcvzpgcqb3bx162fxy299h8arkjhmv8gafl5ja6lnq9l5iqbzv";
  }) { inherit pkgs; };
in
  with pkgs;
  mkShell {
    buildInputs = with elmTools; [ elm-test elm-verify-examples ];
  }
```

nixos configuration remote install:

```nix
{ pkgs, ... }:

let
  elmTools = import (pkgs.fetchFromGitHub {
    owner = "turboMaCk";
    repo = "nix-elm-tools";
    rev = "b2c9d05796c85eeaf2424fc3ce7da4a16bb5ae48";
    sha256 = "1gzcvzpgcqb3bx162fxy299h8arkjhmv8gafl5ja6lnq9l5iqbzv";
  }) { inherit pkgs; };
in {
    environment.systemPackages = with pkgs.elmPackages; [
        elm
        elm-format
        pkgs.elm2nix
        elmTools.elm-test
        elmTools.elm-verify-examples
        elmTools.elm-analyse
        elmTools.elm-doc-preview
    ];
}
```

## Developement

All contributions are welcome. If you want to add a tool available via npm,
add it to `packages.json` and generete new nix files using `generate.sh`.

```
$ ./generate.sh
```

In order to make the tool exposed to the end user
edit the `default.nix` file and add it to the set it defines.
Some tools depends on `elmi-to-json` binary (usually installed
via npm with `binwrap`).
`binwrap` installation is not compatible with nix out of the box.
See `elm-test` as an example of how such package can be patched
by expressions provided as part of this repository.

## Get More!

If you're nix user you should definitely try awesome [elm2nix](https://github.com/hercules-ci/elm2nix).
Big shouts to [@domenkozar](https://github.com/hercules-ci/elm2nix/commits?author=domenkozar)
and the whole [herokus-ci](https://hercules-ci.com/) for their work.
