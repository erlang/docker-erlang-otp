
#FROM buildpack-deps:x32
#FROM gentoo-x32
FROM buildpack-deps-x32:jessie

ENV OTP_VERSION="19.0-rc0@e038cbe"

RUN set -xe \
	&& OTP_DOWNLOAD_SHA1=48186302a5031033aad4e1b8b7a676554d4c3bbb \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/${OTP_VERSION##*@}.tar.gz" \
	&& curl -fSL -o otp-src.tar.gz $OTP_DOWNLOAD_URL \
	&& echo "$OTP_DOWNLOAD_SHA1  otp-src.tar.gz" | sha1sum -c - \
	&& mkdir -p /usr/src/otp-src \
	&& tar -xzC /usr/src/otp-src --strip-components=1 -f otp-src.tar.gz \
	&& rm otp-src.tar.gz \
	&& cd /usr/src/otp-src \
	&& curl -fSL https://github.com/erlang/otp/commit/f7987aa9b.patch | patch -p1 \
	&& ./otp_build autoconf \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples | xargs rm -rf \
	&& rm -rf /usr/src/otp-src

CMD ["erl"]
