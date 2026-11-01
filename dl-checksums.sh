#!/usr/bin/env sh
set -e
MIRROR=https://github.com/loft-sh/vcluster/releases/download

# https://github.com/loft-sh/vcluster/releases/download/v0.11.2/vcluster-linux-amd64.sha256

TMPDIR_=$(mktemp -d)
trap 'rm -rf "$TMPDIR_"' EXIT

dl()
{
    ver=$1
    lhashes=$2
    os=$3
    arch=$4
    dotexe=${5:-""}
    platform="${os}-${arch}"
    file="vcluster-${platform}${dotexe}"
    url="${MIRROR}/v${ver}/${file}"
    sum=$(awk -v f="$file" '$2 == f || $2 == "*" f { print $1 }' "$lhashes")
    if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'
    then
        echo "no valid sha256 for $file in $lhashes" >&2
        exit 1
    fi
    printf "    # %s\n" "$url"
    printf "    %s: sha256:%s\n" "$platform" "$sum"
}

dl_ver() {
    ver=$1

    lhashes="${TMPDIR_}/vcluster-checksums-${ver}.txt"

    # https://github.com/loft-sh/vcluster/releases/download/v0.15.4/checksums.txt
    url="${MIRROR}/v${ver}/checksums.txt"

    curl -fsSL --proto '=https' --tlsv1.2 -o "$lhashes" "$url"

    printf "  # %s\n" "$url"
    printf "  '%s':\n" "$ver"
    dl "$ver" "$lhashes" darwin amd64
    dl "$ver" "$lhashes" darwin arm64
    dl "$ver" "$lhashes" linux amd64
    dl "$ver" "$lhashes" linux arm64
    dl "$ver" "$lhashes" windows amd64 .exe
}

dl_ver "${1:-0.37.5}"
