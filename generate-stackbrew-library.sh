#!/bin/bash
set -eu

declare -a -r versions=(28 27 26 25 24)
declare -A -r aliases=(
	[28]='latest'
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
      versionStr = substr($2, RSTART + 1, RLENGTH - 2)

      # Preserve release candidate (-rcX) if present
      if (match(versionStr, /-rc[0-9]+$/)) {
        rcPart = substr(versionStr, RSTART)
        versionCore = substr(versionStr, 1, RSTART - 1)
      } else {
        rcPart = ""
        versionCore = versionStr
      }

      versionStrLength = split(versionCore, versionStrArray, ".")
      if (versionStrLength > 3) {
        print versionCore rcPart
      } else if (versionStrLength > 2) {
        print versionCore ".0" rcPart
      } else {
        print versionCore ".0.0" rcPart
      }
      exit
    }'
}

self="${BASH_SOURCE##*/}"

cat <<-EOH
# this file is generated via https://github.com/erlang/docker-erlang-otp/blob/$(fileCommit "$self")/$self

Maintainers: Mr C0B <denc716@gmail.com> (@c0b)
GitRepo: https://github.com/erlang/docker-erlang-otp.git
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

		variantArches=( amd64 arm32v5 arm32v7 arm64v8 i386 mips64le ppc64le s390x)

		case "$version" in
		    25|24|23|22|21|20|19|18)
				variantArches=( ${variantArches[@]/s390x} )
				variantArches=( ${variantArches[@]/ppc64le} )
                variantArches=( ${variantArches[@]/mips64le} )
                variantArches=( ${variantArches[@]/arm32v5} )
		esac

		case "$variant" in
			alpine)
				variantArches=( ${variantArches[@]/mips64le} )
				variantArches=( ${variantArches[@]/arm32v5} )
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
