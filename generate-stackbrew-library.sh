#!/bin/bash
set -eu

declare -a -r versions=( 20 19 18 17 )
declare -A -r aliases=(
	[20]='latest'
)

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		fileCommit \
			Dockerfile \
			$(git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						print $i
					}
				}
			')
	)
}

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}%s" "$@"
	echo "${out#$sep}"
}

extractVersion() {
  awk '
        $1 == "ENV" && /_VERSION/ {
        match($2, /"(.*)"/)
        print substr($2, RSTART + 1, RLENGTH - 2)
        exit
      }'

}

self="${BASH_SOURCE##*/}"

cat <<-EOH
# this file is generated via https://github.com/c0b/docker-erlang-otp/blob/$(fileCommit "$self")/$self

Maintainers: Mr C0B <denc716@gmail.com> (@c0b)
GitRepo: https://github.com/c0b/docker-erlang-otp.git
EOH

for version in "${versions[@]}"; do
	commit="$(dirCommit "$version")"

	fullVersion="$(git show "$commit":"$version/Dockerfile" | extractVersion)"

	versionAliases=( $fullVersion )
	while :; do
		localVersion="${fullVersion%.*}"
		if [ "$localVersion" = "$version" ]; then
			break
		fi
		versionAliases+=( $localVersion )
		fullVersion=$localVersion
		# echo "${versionAliases[@]}"
	done
	versionAliases+=( $version ${aliases[$version]:-} )

	for variant in '' slim alpine; do
		dir="$version${variant:+/$variant}"
		[ -f "$dir/Dockerfile" ] || continue

		commit="$(dirCommit "$dir")"

		variantAliases=( "${versionAliases[@]}" )
		if [ -n "$variant" ]; then
			variantAliases=( "${variantAliases[@]/%/-$variant}" )
			variantAliases=( "${variantAliases[@]//latest-/}" )
		fi

		case "$variant" in
			alpine) variantArches=( amd64 ) ;; # TODO https://github.com/gliderlabs/docker-alpine/issues/304
			*)
				variantArches=( amd64 arm32v7 arm64v8 i386 s390x )
				case "$version" in
					18|19) ;; # "/usr/lib/gcc/powerpc64le-linux-gnu/4.9/../../../powerpc64le-linux-gnu/libutil.so: error adding symbols: File in wrong format"
					*) variantArches+=( ppc64le ) ;;
				esac
				;;
		esac

		echo
		cat <<-EOE
			Tags: $(join ', ' "${variantAliases[@]}")
			Architectures: $(join ', ' "${variantArches[@]}")
			GitCommit: $commit
			Directory: $dir
		EOE
	done
done
