FROM buildpack-deps:jessie

ENV OTP_VERSION="20.0-rc2@b833a06"

# We'll install the build dependencies for erlang-odbc along with the erlang
# build process:
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/${OTP_VERSION#*@}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="ae89c2228eb1d8e868138610e0eb5fe2490557e186273d8e12eb94daf7f4c443" \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256 otp-src.tar.gz" | sha256sum -c - \
	&& runtimeDeps='libodbc1 \
			libsctp1 \
			libwxgtk3.0-0' \
	&& buildDeps='unixodbc-dev \
			libsctp-dev \
			libwxgtk3.0-dev' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $runtimeDeps \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%@*}" \
	&& mkdir -vp $ERL_TOP \
	&& tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& ( cd $ERL_TOP \
	  && ./otp_build autoconf \
	  && sed -i -e '/utils\/gen_git_version/c\\\
	@echo GIT_VSN=-DERLANG_GIT_VERSION="\\"\\\\\\""'${OTP_VERSION#*@}'\\\\"\\"\\"" > $@' ./erts/emulator/Makefile.in \
	  && ./configure \
		--enable-dirty-schedulers \
	  && make -j$(nproc) \
	  && make install ) \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf $ERL_TOP /var/lib/apt/lists/*

CMD ["erl"]

# extra useful tools here: rebar & rebar3

ENV REBAR_VERSION="2.6.4"

RUN set -xe \
	&& REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz" \
	&& REBAR_DOWNLOAD_SHA256="577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07" \
	&& curl -fSL -o rebar-src.tar.gz "$REBAR_DOWNLOAD_URL" \
	&& echo "$REBAR_DOWNLOAD_SHA256 rebar-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/src/rebar-src \
	&& tar -xzf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
	&& rm rebar-src.tar.gz \
	&& cd /usr/src/rebar-src \
	&& ./bootstrap \
	&& install -v ./rebar /usr/local/bin/ \
	&& rm -rf /usr/src/rebar-src

ENV REBAR3_VERSION="3.4.1"

RUN set -xe \
	&& REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
	&& REBAR3_DOWNLOAD_SHA256="fa8b056c37ed3781728baf0fc5b1d87a31edbc5f8dd9b50a5d1ad92b0230e5dd" \
	&& curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
	&& echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
	&& mkdir -p /usr/src/rebar3-src \
	&& tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
	&& rm rebar3-src.tar.gz \
	&& cd /usr/src/rebar3-src \
	&& HOME=$PWD ./bootstrap \
	&& install -v ./rebar3 /usr/local/bin/ \
	&& rm -rf /usr/src/rebar3-src

ENV DUMBINIT_VERSION="1.2.0"

RUN set -xe \
	&& DUMBINIT_DOWNLOAD_URL="https://github.com/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_amd64" \
	&& DUMBINIT_DOWNLOAD_SHA256=81231da1cd074fdc81af62789fead8641ef3f24b6b07366a1c34e5b059faf363 \
	&& curl -fSL -o /usr/local/bin/dumb-init "$DUMBINIT_DOWNLOAD_URL" \
	&& echo "$DUMBINIT_DOWNLOAD_SHA256  /usr/local/bin/dumb-init" | sha256sum -c - \
	&& chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
