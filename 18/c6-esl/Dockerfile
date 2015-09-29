FROM centos:6

ENV OTP_VERSION 18.1
ENV LANG C.UTF-8

RUN set -xe \
	&& ESL_URL=http://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/ \
	&& OTP_FILENAME=esl-erlang_$OTP_VERSION-1~centos~6_amd64.rpm \
	&& OTP_DOWNLOAD_URL=$ESL_URL/$OTP_FILENAME \
	&& curl -SL $OTP_DOWNLOAD_URL -O \
	&& curl -SL $OTP_DOWNLOAD_URL.md5 | md5sum -c - \
	&& rpm --nodeps -i $OTP_FILENAME \
	&& rm $OTP_FILENAME

CMD ["erl"]
