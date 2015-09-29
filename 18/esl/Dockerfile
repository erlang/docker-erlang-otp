FROM buildpack-deps:jessie-curl

ENV OTP_VERSION 18.1
ENV LANG C.UTF-8

RUN set -xe \
	&& ESL_URL=http://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/ \
	&& OTP_FILENAME=esl-erlang_$OTP_VERSION-1~debian~jessie_amd64.deb \
	&& OTP_DOWNLOAD_URL=$ESL_URL/$OTP_FILENAME \
	&& curl -SL $OTP_DOWNLOAD_URL -O \
	&& curl -SL $OTP_DOWNLOAD_URL.md5 | md5sum -c - \
	&& dpkg --force-depends -i $OTP_FILENAME \
	&& rm $OTP_FILENAME

CMD ["erl"]
