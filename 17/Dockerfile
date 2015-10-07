FROM buildpack-deps:jessie

ENV OTP_VERSION 17.5.6.4

ENV LANG C.UTF-8

RUN set -xe \
	&& OTP_DOWNLOAD_URL=https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz \
	&& OTP_DOWNLOAD_SHA1=8436bbc750dc90580842e907f911255228d2d070 \
	&& curl -SL $OTP_DOWNLOAD_URL -o otp-src.tar.gz \
	&& echo "$OTP_DOWNLOAD_SHA1  otp-src.tar.gz" | sha1sum -c - \
	&& mkdir -p /usr/src/otp-src \
	&& tar -xzC /usr/src/otp-src --strip-components=1 -f otp-src.tar.gz \
	&& rm otp-src.tar.gz \
	&& cd /usr/src/otp-src \
	&& ./otp_build autoconf \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples |xargs rm -rf \
	&& rm -rf /usr/src/otp-src

CMD ["erl"]
