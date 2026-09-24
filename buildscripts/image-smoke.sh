#!/bin/sh
# Smoke test for the mc release image.
#
#   buildscripts/image-smoke.sh <image> <release-tag> [commit]
#
# Checks the ways consumers run the image: mc prints the release (and the
# commit when given); mc runs through `/bin/sh -c`, as compose and
# Kubernetes init steps do; and as UID 1000 with HOME=/tmp and
# MC_CONFIG_DIR=/tmp/.mc, the Kubernetes examples' securityContext, mc can
# write its configuration. Talking to a server is covered by the minio
# image's smoke test, which creates a bucket with this image.
#
# Needs docker (DOCKER=podman works).
set -eu

image=$1
release=$2
commit=${3:-}
docker=${DOCKER:-docker}

fail() {
	echo "FAIL: $*" >&2
	exit 1
}

want="mc version $release"
[ -z "$commit" ] || want="$want (commit-id=$commit)"
out=$($docker run --rm "$image" --version)
case $out in
*"$want"*) echo "ok: $want" ;;
*) fail "--version printed: $out" ;;
esac

out=$($docker run --rm --entrypoint /bin/sh "$image" -c 'mc --version && echo shell-ok')
case $out in
*shell-ok*) echo "ok: mc through /bin/sh -c" ;;
*) fail "/bin/sh -c printed: $out" ;;
esac

$docker run --rm --user 1000:1000 -e HOME=/tmp -e MC_CONFIG_DIR=/tmp/.mc \
	--entrypoint /bin/sh "$image" -c \
	'mc alias set smoke http://127.0.0.1:9 minioadmin minioadmin --api S3v4 --path auto >/dev/null && mc alias list smoke >/dev/null' ||
	fail "mc alias set as UID 1000"
echo "ok: mc writes its configuration as UID 1000"

echo "smoke: all checks passed for $image"
