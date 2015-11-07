
FROM otp:18.1

ENV ELIXIR_VERSION=1.1.1
ENV LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz" \
	&& ELIXIR_DOWNLOAD_SHA1=d0b213c768b58436f293adab47c0e38715ac01f7 \
	&& curl -fsSL $ELIXIR_DOWNLOAD_URL -o elixir-src.tar.gz \
	&& echo "$ELIXIR_DOWNLOAD_SHA1 elixir-src.tar.gz" | sha1sum -c - \
	&& mkdir -p /usr/src/elixir-src \
	&& tar -xzf elixir-src.tar.gz -C /usr/src/elixir-src --strip-components=1 \
	&& rm elixir-src.tar.gz \
	&& cd /usr/src/elixir-src \
	&& make -j$(nproc) \
	&& make install \
	&& rm -rf /usr/src/elixir-src

CMD ["iex"]
