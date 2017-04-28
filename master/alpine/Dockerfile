FROM alpine:3.5

ENV OTP_VERSION="20.0-rc1@9ac8bdb"

RUN set -xe \
	&& OTP_DOWNLOAD_URL="http://github.com/erlang/otp/archive/${OTP_VERSION##*@}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="9926b1d8382eb7cf61b70ed6e566a86805676d737f7afd349adc3b0ffcde1374" \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		autoconf \
		ncurses-dev \
		curl \
		tar \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
	&& mkdir -vp $ERL_TOP \
	&& tar -f otp-src.tar.gz -C $ERL_TOP --strip-components=1 -zxvv \
	&& rm otp-src.tar.gz \
	&& ( cd $ERL_TOP \
	  && ./otp_build autoconf \
	  && sed -i -e '/utils\/gen_git_version/c\\\
	@echo GIT_VSN=-DERLANG_GIT_VERSION="\\"\\\\\\""'${OTP_VERSION##*@}'\\\\"\\"\\"" > $@' ./erts/emulator/Makefile.in \
	  && export OTP_SMALL_BUILD=true \
	  && ./configure \
		--enable-dirty-schedulers \
	  && make -j$(getconf _NPROCESSORS_ONLN) \
	  && make install ) \
	&& rm -rf $ERL_TOP \
	&& find /usr/local -regex '/usr/local/lib/erlang/\(lib/\|erts-\).*/\(man\|doc\|src\|info\|include\|examples\)' | xargs rm -rf \
	&& rm -rf /usr/local/lib/erlang/lib/*tools* \
		/usr/local/lib/erlang/lib/*test* \
		/usr/local/lib/erlang/usr \
		/usr/local/lib/erlang/misc \
		/usr/local/lib/erlang/erts*/lib/lib*.a \
		/usr/local/lib/erlang/erts*/lib/internal \
	&& scanelf --nobanner -E ET_EXEC -BF '%F' --recursive /usr/local | xargs strip --strip-all \
	&& scanelf --nobanner -E ET_DYN -BF '%F' --recursive /usr/local | xargs -r strip --strip-unneeded \
	&& runDeps=$( \
		scanelf --needed --nobanner --recursive /usr/local \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	) \
	&& apk add --virtual .erlang-rundeps $runDeps \
	&& apk del .build-deps

CMD ["erl"]
