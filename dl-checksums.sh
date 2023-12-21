#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/loft-sh/vcluster/releases/download

# https://github.com/loft-sh/vcluster/releases/download/v0.11.2/vcluster-linux-amd64.sha256

dl()
{
    local ver=$1
    local lhashes=$2
    local os=$3
    local arch=$4
    local dotexe=${5:-""}
    local platform="${os}-${arch}"
    local file="vcluster-${platform}${dotexe}"
    local url="${MIRROR}/v${ver}/${file}"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(egrep -e "${file}\$" $lhashes | awk '{ print $1 }')
}

dl_ver() {
    local ver=$1

    local lhashes="${DIR}/vcluster-checksums-${ver}.txt"

    # https://github.com/loft-sh/vcluster/releases/download/v0.15.4/checksums.txt
    local url="${MIRROR}/v${ver}/checksums.txt"

    if [ ! -e "${lhashes}" ];
    then
        curl -sSLf -o $lhashes $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver
    dl $ver $lhashes darwin amd64
    dl $ver $lhashes darwin arm64
    dl $ver $lhashes linux amd64
    dl $ver $lhashes linux arm64
    dl $ver $lhashes windows amd64 .exe
}

dl_ver ${1:-0.18.1}
