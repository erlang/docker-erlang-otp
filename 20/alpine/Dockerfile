FROM alpine:3.5

ENV OTP_VERSION="20.0-rc1"

RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="9d31979ea4f95553389910c74b8a709992697d8bc7ebeb9a65726d2bd97ab900" \
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
	&& tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& ( cd $ERL_TOP \
	  && echo "${OTP_VERSION}" > ./OTP_VERSION \
	  && ./otp_build autoconf \
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
