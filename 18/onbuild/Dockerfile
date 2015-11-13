FROM erlang:18

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY rebar.config /usr/src/app/
ONBUILD RUN rebar3 update
ONBUILD COPY . /usr/src/app
ONBUILD RUN rebar3 release

CMD [ "rebar3", "shell" ]
