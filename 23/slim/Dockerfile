FROM debian:buster

ENV OTP_VERSION="23.2.3"

LABEL org.opencontainers.image.version=$OTP_VERSION

# We'll install the build dependencies, and purge them on the last step to make
# sure our final image contains only what we've just built:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="3160912856ba734bd9c17075e72f469b9d4b913f3ab9652ee7e0fb406f0f0f2c" \
	&& fetchDeps=' \
		curl \
		ca-certificates' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $fetchDeps \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
	&& runtimeDeps=' \
		libodbc1 \
		libssl1.1 \
		libsctp1 \
	' \
	&& buildDeps=' \
		autoconf \
		dpkg-dev \
		gcc \
		g++ \
		make \
		libncurses-dev \
		unixodbc-dev \
		libssl-dev \
		libsctp-dev \
	' \
	&& apt-get install -y --no-install-recommends $runtimeDeps \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
	&& mkdir -vp $ERL_TOP \
	&& tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& ( cd $ERL_TOP \
	  && ./otp_build autoconf \
	  && gnuArch="$(dpkg-architecture --query DEB_HOST_GNU_TYPE)" \
	  && ./configure --build="$gnuArch" \
	  && make -j$(nproc) \
	  && make install ) \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y --auto-remove $buildDeps $fetchDeps \
	&& rm -rf $ERL_TOP /var/lib/apt/lists/*

CMD ["erl"]
