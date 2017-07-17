FROM buildpack-deps:jessie

ENV OTP_VERSION=R16B03-1 LANG=C.UTF-8

RUN set -xe \
	&& OTP_DOWNLOAD_MD5=e5ece977375197338c1b93b3d88514f8 \
	&& buildDeps='unixodbc-dev' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o otp-src.tar.gz http://www.erlang.org/download/otp_src_$OTP_VERSION.tar.gz \
	&& echo "$OTP_DOWNLOAD_MD5  otp-src.tar.gz" | md5sum -c - \
	&& mkdir -p /usr/src/otp-src \
	&& tar -xzC /usr/src/otp-src --strip-components=1 -f otp-src.tar.gz \
	&& rm otp-src.tar.gz \
	&& cd /usr/src/otp-src \
	&& ./configure \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /usr/src/otp-src /var/lib/apt/lists/*

ENV DUMBINIT_VERSION="1.2.0"

RUN set -xe \
	&& DUMBINIT_DOWNLOAD_URL="https://github.com/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_amd64" \
	&& DUMBINIT_DOWNLOAD_SHA256=81231da1cd074fdc81af62789fead8641ef3f24b6b07366a1c34e5b059faf363 \
	&& curl -fSL -o /usr/local/bin/dumb-init "$DUMBINIT_DOWNLOAD_URL" \
	&& echo "$DUMBINIT_DOWNLOAD_SHA256  /usr/local/bin/dumb-init" | sha256sum -c - \
	&& chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD ["erl"]
