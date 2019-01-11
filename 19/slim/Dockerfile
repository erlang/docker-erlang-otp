FROM debian:stretch

ENV OTP_VERSION="19.3.6.13"

# We'll install the build dependencies, and purge them on the last step to make
# sure our final image contains only what we've just built:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="11a914176a33068226644f4e999ecc6e965ab1c60a324d90020f164641631fae" \
	&& runtimeDeps=' \
		libodbc1 \
		libssl1.0.2 \
		libsctp1 \
		libwxgtk3.0 \
	' \
	&& buildDeps=' \
		curl \
		ca-certificates \
		autoconf \
		dpkg-dev \
		gcc \
		g++ \
		make \
		libncurses-dev \
		unixodbc-dev \
		libssl1.0-dev \
		libsctp-dev \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $runtimeDeps \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256 otp-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/src/otp-src \
	&& tar -xzf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& cd /usr/src/otp-src \
	&& ./otp_build autoconf \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure --build="$gnuArch" \
		--enable-dirty-schedulers \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /usr/src/otp-src /var/lib/apt/lists/*

CMD ["erl"]
