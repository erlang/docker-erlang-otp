FROM alpine:3.6

ENV OTP_VERSION="21.0-rc0@72d994d"

RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/${OTP_VERSION#*@}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="16bf8476b2c681f92a9595d3520a6f77c0f8eaf8efea6181147516d026b82fbf" \
	&& apk add --no-cache --virtual .fetch-deps \
		curl \
		ca-certificates \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		autoconf \
		ncurses-dev \
		openssl-dev \
		tar \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%@*}" \
	&& mkdir -vp $ERL_TOP \
	&& tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& ( cd $ERL_TOP \
	  && ./otp_build autoconf \
	  && sed -i -e '/utils\/gen_git_version/c\\\
	@echo GIT_VSN=-DERLANG_GIT_VERSION="\\"\\\\\\""'${OTP_VERSION#*@}'\\\\"\\"\\"" > $@' ./erts/emulator/Makefile.in \
	  && ./configure \
	  && make -j$(getconf _NPROCESSORS_ONLN) \
	  && make install ) \
	&& rm -rf $ERL_TOP \
	&& find /usr/local -regex '/usr/local/lib/erlang/\(lib/\|erts-\).*/\(man\|doc\|src\|obj\|c_src\|emacs\|info\|examples\)' | xargs rm -rf \
	&& rm -rf \
		/usr/local/lib/erlang/erts*/lib/lib*.a \
		/usr/local/lib/erlang/usr/lib/lib*.a \
		/usr/local/lib/erlang/lib/*/lib/lib*.a \
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
	&& apk del .fetch-deps .build-deps

CMD ["erl"]
