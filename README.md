# The Official Erlang OTP images

[![dockeri.co](http://dockeri.co/image/_/erlang)](https://hub.docker.com/_/erlang/)

[![Docker Stars](https://img.shields.io/docker/stars/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Docker Pulls](https://img.shields.io/docker/pulls/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Image Layers](https://images.microbadger.com/badges/image/erlang.svg)](https://microbadger.com/images/erlang "Get your own image badge on microbadger.com")

[![Build Status](https://travis-ci.org/erlang/docker-erlang-otp.svg?branch=master)](https://travis-ci.org/erlang/docker-erlang-otp)

This is used as docker base image for Erlang OTP.
The goal is to provide images for a few last erlang releases (currently 21/ 20 / 19 / 18), in close to full feature Erlang OTP, and relatively slim images. Support to 17, R16 and R15 are provided in this repo on a best-effort basis, and not part of official-image effort in docker-library/official-images#1075 .

### use the Erlang 21

here is providing the latest Erlang 21 image; you may pull from official-images or build it locally:

```console
$ docker build -t erlang:21.0 ./21
[...]
➸ docker run -it --rm erlang:21.0
Erlang/OTP 21 [erts-10.0] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V10.0  (abort with ^G)
1> erlang:system_info(otp_release).
"21"
2> os:getenv().
["PWD=/","REBAR3_VERSION=3.5.3",
"ROOTDIR=/usr/local/lib/erlang","LANG=C.UTF-8",
"PATH=/usr/local/lib/erlang/erts-10.0/bin:/usr/local/lib/erlang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
"REBAR_VERSION=2.6.4","TERM=xterm",
"BINDIR=/usr/local/lib/erlang/erts-10.0/bin","PROGNAME=erl",
"EMU=beam","OTP_VERSION=21.0","HOME=/root",
"HOSTNAME=9b1e7f4d7206"]
3> 'hello_юникод_世界'.                                   % Erlang20 now support unicode in atom
'hello_юникод_世界'
4> io:format("~tp~n", [{'hello_юникод', <<"Hello, 世界; юникод"/utf8>>, "Hello, 世界; юникод"}]).
{'hello_юникод',<<"Hello, 世界; юникод"/utf8>>,"Hello, 世界; юникод"}
ok
5> try 1/0 catch C:R:Stacktrace -> logger:error("caught: ~tp~n", [{C,R,Stacktrace}]) end. %% Erlang 21 now has new API for logging, logger
=ERROR REPORT==== 20-Jun-2018::07:23:13.384474 ===
caught: {error,badarith,
               [{erlang,'/',[1,0],[]},
                {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,681}]},
                {erl_eval,try_clauses,8,[{file,"erl_eval.erl"},{line,911}]},
                {shell,exprs,7,[{file,"shell.erl"},{line,686}]},
                {shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                {shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}

ok
```

#### Features

1. observer is a wx widget application, the GUI may require different protocol
   for different OSes, for Linux it requires X11 protocol be properly setup
   this wiki has setup for Linux desktop for observer use in elixir, which also applies to Erlang
   https://github.com/c0b/docker-elixir/wiki/use-observer
2. dirty scheduler is enabled since Erlang 19 images;

Read from https://github.com/erlang/otp/releases for each tag description as release annoucement.

### Design

1. the standard variant `erlang:21`, `erlang:20`, `erlang:19`, `erlang:18`, builds from source code,
   based on [`buildpack-deps:stretch`](https://hub.docker.com/_/buildpack-deps/);
   it covered gcc compiler and some popular -dev packages, for those erlang port drivers written in C; while it doesn't have java compiler so jinterface doesn't compile, assuming demand to write java code for erlang applications is low;
2. the `-onbuild` variant is deprecated; for more details, see [docker-library/official-images#2076](https://github.com/docker-library/official-images/issues/2076).
3. the slim version is built from `debian:stretch` install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, to shrink image size;
4. the alpine version is built from last alpine stable image, install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, also removed src/\*.erl include/\*.hrl / all docs (include man info) / examples / static archives / build and unittest tools, and strip the ELF binaries, to get a really slim image, ideally smaller than 20MB;
5. rebar and rebar3 tool is bundled in `erlang:21`, `erlang:20`, `erlang:19` and `erlang:18` image;

### Sizes

```console
$ docker images --filter=reference='erlang:*'
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
erlang              21.0-alpine         288ccf67e12b        7 hours ago         71.1MB
erlang              21.0-slim           ebc139e56d88        7 hours ago         254MB
erlang              21.0                76f0c5e69a48        7 hours ago         1.06GB
erlang              20.3-alpine         4427af07b1fe        5 days ago          75.5MB
erlang              20.3-slim           a5da071ec577        5 days ago          263MB
erlang              20.3                b6e79a9bd68a        5 days ago          1.07GB
erlang              18.3                91333142fa40        2 weeks ago         754MB
erlang              19.3                2ea95f0c3147        2 weeks ago         886MB
erlang              18.3-slim           f82b65021cfc        2 weeks ago         287MB
erlang              19.3-slim           4f720aaec27c        2 weeks ago         440MB
```

### Running

```console
$ docker run -it --rm erlang:21.0 /bin/bash
root@ed434f6c1081:/# ls /usr/local/lib/erlang/lib/
asn1-5.0.6        erl_interface-3.10.3  observer-2.8        ssh-4.7
common_test-1.16  erts-10.0             odbc-2.12.1         ssl-9.0
compiler-7.2      et-1.6.2              os_mon-2.4.5        stdlib-3.5
crypto-4.3        eunit-2.3.6           otp_mibs-1.2        syntax_tools-2.1.5
debugger-4.2.5    ftp-1.0               parsetools-2.1.7    tftp-1.0
dialyzer-3.3      hipe-3.18             public_key-1.6      tools-3.0
diameter-2.1.5    inets-7.0             reltool-0.7.6       wx-1.8.4
edoc-0.9.3        kernel-6.0            runtime_tools-1.13  xmerl-1.3.17
eldap-1.2.4       megaco-3.18.3         sasl-3.2
erl_docgen-0.8    mnesia-4.15.4         snmp-5.2.11
root@ed434f6c1081:/# ls /usr/local/lib/erlang/lib/ | wc -l
38
```

The official release 21 https://github.com/erlang/otp/tree/maint-21/lib has 39 libs, while here by default it provided 38 of them (plus erts-10.0 from erlang itself), except jinterface, because to build that one would pull all jdk dependencies and make the image too fat; if you really need that to write code in java and interface into erlang code, you may create an issue here to ask for it.
