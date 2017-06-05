# The Official Erlang OTP images

[![dockeri.co](http://dockeri.co/image/_/erlang)](https://hub.docker.com/_/erlang/)

[![Docker Stars](https://img.shields.io/docker/stars/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Docker Pulls](https://img.shields.io/docker/pulls/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Image Layers](https://badge.imagelayers.io/erlang:latest.svg)](https://imagelayers.io/?images=erlang:latest 'Show Image Layers at imagelayers.io')

[![Build Status](https://travis-ci.org/c0b/docker-erlang-otp.svg?branch=master)](https://travis-ci.org/c0b/docker-erlang-otp)

This is used as docker base image for Erlang OTP.
The goal is to provide images for a few last erlang releases (currently 20 / 19 / 18), in close to full feature Erlang OTP, and relatively slim images. Support to 17, R16 and R15 are provided in this repo on a best-effort basis, and not part of official-image effort in docker-library/official-images#1075 .

### use the Erlang 20

here is providing the latest Erlang 20 image; you may pull from official-images or build it locally:

```console
$ docker build -t erlang:20.0-rc1 ./20
[...]
➸ docker run -it --rm erlang:20.0-rc1
Erlang/OTP 20 [RELEASE CANDIDATE 1] [erts-9.0] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V9.0  (abort with ^G)
1> erlang:system_info(otp_release).
"20"
2> os:getenv().
["PWD=/","REBAR3_VERSION=3.3.6",
"ROOTDIR=/usr/local/lib/erlang","LANG=C.UTF-8",
"PATH=/usr/local/lib/erlang/erts-9.0/bin:/usr/local/lib/erlang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
"REBAR_VERSION=2.6.4","TERM=xterm",
"BINDIR=/usr/local/lib/erlang/erts-9.0/bin","PROGNAME=erl",
"EMU=beam","OTP_VERSION=20.0-rc1","HOME=/root",
"HOSTNAME=9b1e7f4d7206"]
3> 'hello_юникод_世界'.                                   % Erlang20 now support unicode in atom
'hello_юникод_世界'
4> io:format("~tp~n", [{'hello_юникод', <<"Hello, 世界; юникод"/utf8>>, "Hello, 世界; юникод"}]).
{'hello_юникод',<<"Hello, 世界; юникод"/utf8>>,"Hello, 世界; юникод"}
ok
5>
```

#### Features

1. observer is a wx widget application, the GUI may require different protocol
   for different OSes, for Linux it requires X11 protocol be properly setup
   this wiki has setup for Linux desktop for observer use in elixir, which also applies to Erlang
   https://github.com/c0b/docker-elixir/wiki/use-observer
2. dirty scheduler is enabled since Erlang 19 images;

Read from https://github.com/erlang/otp/releases for each tag description as release annoucement.

### Design

1. the standard variant `erlang:20`, `erlang:19`, `erlang:18`, builds from source code,
   based on [`buildpack-deps:jessie`](https://hub.docker.com/_/buildpack-deps/);
   it covered gcc compiler and some popular -dev packages, for those erlang port drivers written in C; while it doesn't have java compiler so jinterface doesn't compile, assuming demand to write java code for erlang applications is low;
2. the `-onbuild` variant is deprecated; for more details, see [docker-library/official-images#2076](https://github.com/docker-library/official-images/issues/2076).
3. the slim version is built from `debian:jessie` install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, to shrink image size;
4. the alpine version is built from last alpine stable image, install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, also removed src/\*.erl include/\*.hrl / all docs (include man info) / examples / static archives / build and unittest tools, and strip the ELF binaries, to get a really slim image, ideally smaller than 20MB;
5. rebar and rebar3 tool is bundled in `erlang:20`, `erlang:19` and `erlang:18` image;

### Sizes

```console
$ docker images --filter=reference='erlang:*'
REPOSITORY TAG             IMAGE ID       CREATED          SIZE
erlang     20.0-rc1        84eea457a726   2 seconds ago    809.7 MB
erlang     20.0-rc1-alpine dd870a4a2424   9 minutes ago    18.9 MB
erlang     20.0-rc1-slim   50391255ea5a   14 minutes ago   362.2 MB
erlang     19.3            2216344f0c70   32 hours ago     821.4 MB
erlang     19.3-slim       11724662809a   31 hours ago     374.9 MB
erlang     18.3            9f92145c1fac   10 days ago      754.3 MB
erlang     18.3-slim       6d15a17b95d4   11 days ago      284.5 MB
```

### Running

```console
$ docker run -it --rm erlang:20.0-rc1 /bin/bash
root@11ecefc83eb5:/# ls /usr/local/lib/erlang/lib/
asn1-5.0              dialyzer-3.2       kernel-5.3         sasl-3.0.4
common_test-1.15      diameter-1.12.3    megaco-3.18.2      snmp-5.2.5
compiler-7.1          edoc-0.9           mnesia-4.15        ssh-4.5
cosEvent-2.2.1        eldap-1.2.2        observer-2.4       ssl-8.2
cosEventDomain-1.2.1  erl_docgen-0.7     odbc-2.12          stdlib-3.4
cosFileTransfer-1.2.1 erl_interface-3.10 orber-3.8.3        syntax_tools-2.1.2
cosNotification-1.2.2 erts-9.0           os_mon-2.4.2       tools-2.10
cosProperty-1.2.2     et-1.6             otp_mibs-1.1.1     wx-1.8.1
cosTime-1.2.2         eunit-2.3.3        parsetools-2.1.5   xmerl-1.3.14
cosTransactions-1.3.2 hipe-3.16          public_key-1.4.1
crypto-4.0            ic-4.4.2           reltool-0.7.3
debugger-4.2.2        inets-6.3.9        runtime_tools-1.12
root@11ecefc83eb5:/# ls /usr/local/lib/erlang/lib/ | wc -l
45
```

The official release 20 https://github.com/erlang/otp/tree/maint-20/lib has 45 libs, while here by default it provided 44 of them (plus erts-9.0 from erlang itself), except jinterface, because to build that one would pull all jdk dependencies and make the image too fat; if you really need that to write code in java and interface into erlang code, you may create an issue here to ask for it.