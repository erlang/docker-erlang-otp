FROM alpine:3.6

ENV OTP_VERSION="21.0-rc0@50525f3"

RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/${OTP_VERSION#*@}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="d491687d0701e17ca63f2afd8bb69728c6800d57ffc39ed20709a62fcbfb147e" \
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
	  && export OTP_SMALL_BUILD=true \
		EXTRA_APPLICATIONS='\
		  crypto public_key asn1 ssl \
		  erl_interface syntax_tools \
		  eunit dialyzer edoc snmp' \
	  && ./configure \
		--enable-dirty-schedulers \
	  && make -j$(getconf _NPROCESSORS_ONLN) \
	  && make install ) \
	&& rm -rf $ERL_TOP \
	&& find /usr/local -regex '/usr/local/lib/erlang/\(lib/\|erts-\).*/\(man\|doc\|src\|obj\|c_src\|emacs\|info\|examples\)' | xargs rm -rf \
	&& rm -rf \
		/usr/local/lib/erlang/erts*/lib/lib*.a \
		/usr/local/lib/erlang/usr/lib/lib*.a \
		/usr/local/lib/erlang/lib/*/lib/lib*.a \
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
	&& apk del .fetch-deps .build-deps

CMD ["erl"]
