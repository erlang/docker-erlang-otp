FROM buildpack-deps:jessie

ENV OTP_VERSION="18.3.4.5"

# We'll install the build dependencies for erlang-odbc along with the erlang
# build process:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="a27b8ff057f77305e7c9f2dbcd002232856438fd1fdf3822edd27c6f77a60ca1" \
	&& runtimeDeps='libodbc1 \
			libsctp1' \
	&& buildDeps='unixodbc-dev \
			libsctp-dev' \
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
	&& ./configure --enable-sctp \
	&& make -j$(nproc) \
	&& make install \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /usr/src/otp-src /var/lib/apt/lists/*

CMD ["erl"]

# extra useful tools here: rebar & rebar3

ENV REBAR_VERSION="2.6.4"

RUN set -xe \
	&& REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION##*@}.tar.gz" \
	&& REBAR_DOWNLOAD_SHA256="577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07" \
	&& mkdir -p /usr/src/rebar-src \
	&& curl -fSL -o rebar-src.tar.gz "$REBAR_DOWNLOAD_URL" \
	&& echo "$REBAR_DOWNLOAD_SHA256 rebar-src.tar.gz" | sha256sum -c - \
	&& tar -xzf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
	&& rm rebar-src.tar.gz \
	&& cd /usr/src/rebar-src \
	&& ./bootstrap \
	&& install -v ./rebar /usr/local/bin/ \
	&& rm -rf /usr/src/rebar-src

ENV REBAR3_VERSION="3.3.4"

RUN set -xe \
	&& REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION##*@}.tar.gz" \
	&& REBAR3_DOWNLOAD_SHA256="a7ad962617f1e91347257b7c6c69612aee564e1172b8507947e173b8846a204d" \
	&& mkdir -p /usr/src/rebar3-src \
	&& curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
	&& echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
	&& tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
	&& rm rebar3-src.tar.gz \
	&& cd /usr/src/rebar3-src \
	&& HOME=$PWD ./bootstrap \
	&& install -v ./rebar3 /usr/local/bin/ \
	&& rm -rf /usr/src/rebar3-src

ENV DUMBINIT_VERSION="1.2.0"

RUN set -xe \
	&& DUMBINIT_DOWNLOAD_URL="https://github.com/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_amd64" \
	&& curl -fSL -o /usr/local/bin/dumb-init "$DUMBINIT_DOWNLOAD_URL" \
	&& chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
