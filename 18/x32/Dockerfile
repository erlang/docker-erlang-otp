
#FROM buildpack-deps:x32
#FROM gentoo-x32
FROM buildpack-deps-x32:jessie

ENV OTP_VERSION=18.2.3

# We'll install the build dependencies for erlang-odbc along with the erlang
# build process:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
	&& OTP_DOWNLOAD_SHA1="3c530cc8b72a0a5760ab61cd001041eea3de589b" \
	&& OTP_X32_PATCH="https://github.com/erlang/otp/commit/f7987aa9b.patch" \
	&& buildDeps='unixodbc-dev' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA1 otp-src.tar.gz" | sha1sum -c - \
	&& mkdir -p /usr/src/otp-src \
	&& tar -xzf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& cd /usr/src/otp-src \
	&& curl -fSL $OTP_X32_PATCH | patch -p1 \
	&& ./otp_build autoconf \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples |xargs rm -rf \
	&& rm -rf /usr/src/otp-src /var/lib/apt/lists/*

CMD ["erl"]
