FROM buildpack-deps:jessie

ENV OTP_VERSION="17.5.6.9"

# We'll install the build dependencies for erlang-odbc along with the erlang
# build process:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="387c612d1bc5ffbc68db7d05c3655804b310facc8bad921a3e0f3391970bc522" \
	&& runtimeDeps='libodbc1' \
	&& buildDeps='unixodbc-dev' \
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
