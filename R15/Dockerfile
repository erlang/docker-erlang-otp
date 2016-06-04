FROM buildpack-deps:jessie

ENV OTP_VERSION R15B03-1

ENV LANG C.UTF-8

RUN set -xe \
	&& OTP_DOWNLOAD_URL=http://www.erlang.org/download/otp_src_$OTP_VERSION.tar.gz \
	&& OTP_DOWNLOAD_MD5=eccd1e6dda6132993555e088005019f2 \
	&& curl -SL $OTP_DOWNLOAD_URL -o otp-src.tar.gz \
	&& echo "$OTP_DOWNLOAD_MD5  otp-src.tar.gz" | md5sum -c - \
	&& mkdir -p /usr/src/otp-src \
	&& tar -xzC /usr/src/otp-src --strip-components=1 -f otp-src.tar.gz \
	&& rm otp-src.tar.gz \
	&& cd /usr/src/otp-src \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples | xargs rm -rf \
	&& rm -rf /usr/src/otp-src

CMD ["erl"]
