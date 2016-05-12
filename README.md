# About this Repo

[![Docker Stars](https://img.shields.io/docker/stars/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Docker Pulls](https://img.shields.io/docker/pulls/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Image Layers](https://badge.imagelayers.io/erlang:latest.svg)](https://imagelayers.io/?images=erlang:latest 'Show Image Layers at imagelayers.io')

[![Build Status](https://travis-ci.org/c0b/docker-erlang-otp.svg?branch=master)](https://travis-ci.org/c0b/docker-erlang-otp)

This is used as docker base image for Erlang OTP.
The goal is to provide images for a few last erlang releases (currently 19 / 18 / 17), in close to full feature Erlang OTP, and relatively slim images. Support to R16 and R15 are provided in this repo on a best-effort basis, and not part of official-image effort in docker-library/official-images#1075 .

### use the Erlang 19

here is providing a latest Erlang 19-rc1 image, but since master branch is moving fast, official release will be in June 2016; here is not going to push to official-images but you can clone this project and build it locally:

```console
$ docker build -t erlang:19.0-rc1 19/
[...]
➸ docker run -it --rm erlang:19.0-rc1
Erlang/OTP 19 [erts-8.0] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V8.0  (abort with ^G)
1> erlang:system_info(otp_release).
"19"
2> uptime().
6 seconds
ok
3> os:getenv().
["PWD=/","REBAR3_VERSION=3.1.0",
"ROOTDIR=/usr/local/lib/erlang",
"PATH=/usr/local/lib/erlang/erts-8.0/bin:/usr/local/lib/erlang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
"REBAR_VERSION=2.6.1","TERM=xterm",
"BINDIR=/usr/local/lib/erlang/erts-8.0/bin","PROGNAME=erl",
"EMU=beam","OTP_VERSION=OTP-19.0-rc1","HOME=/root",
"HOSTNAME=33697c67c7b0"]
4>
```

Read the release annoucement http://erlang.org/pipermail/erlang-questions/2016-May/089185.html

### Design

1. the standard variant `erlang:18`, `erlang:17`, builds from source code,
   based on [buildpack-deps:jessie](https://hub.docker.com/_/buildpack-deps/);
   it covered gcc compiler and some popular -dev packages, for those erlang port drivers written in C; while it doesn't have java compiler so jinterface doesn't compile, wxwidgets depends on some gl/gtk headers/lib also doesn't compile; I assume to run GUI applications in docker is not popular, so here we can save some space; jinterface is similar, the java dependencies are too fat, I assume demand to write java code for erlang applications is low;
2. the -onbuild variant for each erlang version, to utilize ONBUILD instruction from Dockerfile, those are for starters
3. the slim version is built from `debian:jessie` install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, to shrink image size;
4. rebar and rebar3 tool is bundled in `erlang:18` image, for `-onbuild` images to do something interesting;
5. the `erlang:19` images are built from current master branch of erlang/otp, there is no tag yet, so build it from tags like erlang/otp@e038cbe ; will be ready to build official 19 images when 19 is released in March.

### Sizes

```console
$ docker images |grep ^erlang
REPOSITORY TAG         IMAGE ID       CREATED          SIZE
erlang     19.0-x32    a7bff53623ba   2 minutes ago    699.4 MB
erlang     19.0-rc0    448ce5129d08   7 minutes ago    742.5 MB
erlang     18.2        907bbcb7b07f   43 minutes ago   744.8 MB
erlang     18.2-slim   f4f63e4ef62d   27 hours ago     283.9 MB
erlang     latest      d16b080a468f   27 hours ago     744.8 MB
erlang     17.5-slim   16948ef75f5f   43 hours ago     280.7 MB
erlang     17.5        d16f45f04f42   43 hours ago     740.2 MB
erlang     18.2-slim   8db47440816d   43 hours ago     283.9 MB
erlang     18.2-x32    fe555fc315ae   2 days ago       700.3 MB
erlang     18.1-slim   0d2ef515fa92   21 minutes ago   283.6 MB
erlang     18.1        57cd51bedc4b   35 minutes ago   742.9 MB
```

### Running

```console
$ docker run -it --rm erlang:18.1
Erlang/OTP 18 [erts-7.1] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V7.1  (abort with ^G)
1> uptime().                         # the new uptime() shell command since OTP 18
3 seconds
ok
2> application:which_applications().
[{stdlib,"ERTS  CXC 138 10","2.6"},
 {kernel,"ERTS  CXC 138 10","4.1"}]
3>
User switch command
 --> q
$ docker run -it --rm erlang:18.1 /bin/bash
root@88f845c8c7af:/# ls /usr/local/lib/erlang/lib/
asn1-4.0             diameter-1.11      megaco-3.18          sasl-2.6
common_test-1.11     edoc-0.7.17        mnesia-4.13.2        snmp-5.2
compiler-6.0.1       eldap-1.2          observer-2.1         ssh-4.1.2
cosEvent-2.2         erl_docgen-0.4     odbc-2.11.1          ssl-7.1
cosEventDomain-1.2   erl_interface-3.8  orber-3.8            stdlib-2.6
cosFileTransfer-1.2  erts-7.1           os_mon-2.4           syntax_tools-1.7
cosNotification-1.2  et-1.5.1           ose-1.1              test_server-3.9
cosProperty-1.2      eunit-2.2.11       otp_mibs-1.1         tools-2.8.1
cosTime-1.2          gs-1.6             parsetools-2.1       typer-0.9.9
cosTransactions-1.3  hipe-3.13          percept-0.8.11       webtool-0.9
crypto-3.6.1         ic-4.4             public_key-1.0.1     wx-1.5
debugger-4.1.1       inets-6.0.2        reltool-0.7          xmerl-1.3.8
dialyzer-2.8.1       kernel-4.1         runtime_tools-1.9.1
```

The official release https://github.com/erlang/otp/tree/maint/lib has 52 libs, while here by default it provided 51 of them, except jinterface, because to build that one would pull all jdk dependencies and make this image too fat, it's just avoided here; if you really need that to write code in java and interface into erlang code, you may create an issue for this project.

```
root@88f845c8c7af:/# ls /usr/local/lib/erlang/lib/ |wc -l
51
```

