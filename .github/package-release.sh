#!/usr/bin/env bash
# Stage a CDP release package and archive it.
#
# Layout: a versioned top-level folder (so archives don't extract loose
# files everywhere) containing bin/ with the programs, a README.txt, and
# the LICENSE (the LGPL requires the license to accompany binaries).
#
# Usage: package-release.sh <tag> <platform> <tar|zip>
set -euo pipefail

tag="$1"        # e.g. v8.7.3
platform="$2"   # e.g. linux-x86_64
format="$3"     # tar or zip

pkg="cdp-$tag-$platform"
mkdir -p "$pkg/bin"
cp NewRelease/* "$pkg/bin/"
cp LICENSE "$pkg/"

cat > "$pkg/README.txt" <<EOF
CDP (Composers Desktop Project) — command-line sound transformation programs
https://www.composersdesktop.com

Version:  $tag
Platform: $platform
Built from source by GitHub Actions.

Contents:
  bin/      the CDP command-line programs
  LICENSE   GNU LGPL 2.1

Getting started:
  Add the bin/ folder to your PATH. Run any program without arguments to
  see its usage. For example:
      synth wave 1 out.wav 44100 1 2.0 440
  creates two seconds of a 440 Hz sine wave.

Note for macOS users: these binaries are not code-signed. If your browser
quarantined the download, clear the attribute with:
    xattr -dr com.apple.quarantine bin
EOF

if [ "$format" = zip ]; then
  zip -q -r "$pkg.zip" "$pkg"
else
  tar czf "$pkg.tar.gz" "$pkg"
fi
