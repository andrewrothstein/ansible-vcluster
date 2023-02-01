#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/loft-sh/vcluster/releases/download

# https://github.com/loft-sh/vcluster/releases/download/v0.11.2/vcluster-linux-amd64.sha256

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local dotexe=${4:-""}
    local platform="${os}-${arch}"
    local url=$MIRROR/v${ver}/vcluster-${platform}${dotexe}.sha256
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(curl -sSLf $url)
}

dl_ver() {
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver darwin amd64
    dl $ver darwin arm64
    dl $ver linux amd64
    dl $ver linux arm64
    dl $ver linux 386
    dl $ver windows amd64 .exe
    dl $ver windows 386 .exe
}

dl_ver ${1:-0.14.0}
