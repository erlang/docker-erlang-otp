
#FROM buildpack-deps:x32
#FROM gentoo-x32
FROM buildpack-deps-x32:jessie

ENV OTP_VERSION="18.3"

# We'll install the build dependencies for erlang-odbc along with the erlang
# build process:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="8d5436faf37a1273c1b8529c4f02c28af0eccde31e52d474cb740b012d5da7e6" \
	&& OTP_X32_PATCH="https://github.com/erlang/otp/commit/f7987aa9b.patch" \
	&& buildDeps='unixodbc-dev' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256 otp-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/src/otp-src \
	&& tar -xzf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& cd /usr/src/otp-src \
	&& curl -fSL $OTP_X32_PATCH | patch -p1 \
	&& ./otp_build autoconf \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples | xargs rm -rf \
	&& rm -rf /usr/src/otp-src /var/lib/apt/lists/*

CMD ["erl"]
