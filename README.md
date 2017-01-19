# The Official Erlang OTP images

[![dockeri.co](http://dockeri.co/image/_/erlang)](https://hub.docker.com/_/erlang/)

[![Docker Stars](https://img.shields.io/docker/stars/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Docker Pulls](https://img.shields.io/docker/pulls/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Image Layers](https://badge.imagelayers.io/erlang:latest.svg)](https://imagelayers.io/?images=erlang:latest 'Show Image Layers at imagelayers.io')

[![Build Status](https://travis-ci.org/c0b/docker-erlang-otp.svg?branch=master)](https://travis-ci.org/c0b/docker-erlang-otp)

This is used as docker base image for Erlang OTP.
The goal is to provide images for a few last erlang releases (currently 19 / 18 / 17), in close to full feature Erlang OTP, and relatively slim images. Support to R16 and R15 are provided in this repo on a best-effort basis, and not part of official-image effort in docker-library/official-images#1075 .

### use the Erlang 19

here is providing the latest Erlang 19 image; you may pull from official-images or build it locally:

```console
$ docker build -t erlang:19.0 ./19
[...]
➸ docker run -it --rm erlang:19.0
Erlang/OTP 19 [erts-8.0.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V8.0.2  (abort with ^G)
1> erlang:system_info(otp_release).
"19"
2> uptime().
6 seconds
ok
3> os:getenv().
["PWD=/","REBAR3_VERSION=3.2.0",
 "ROOTDIR=/usr/local/lib/erlang",
 "PATH=/usr/local/lib/erlang/erts-8.0.2/bin:/usr/local/lib/erlang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
 "REBAR_VERSION=2.6.2","TERM=xterm",
 "BINDIR=/usr/local/lib/erlang/erts-8.0.2/bin",
 "PROGNAME=erl","EMU=beam","OTP_VERSION=19.0.3","HOME=/root",
 "HOSTNAME=1c91a740c50a"]
4>
```

#### Features

1. observer is a wx widget application, the GUI may require different protocol
   for different OSes, for Linux it requires X11 protocol be properly setup
   this wiki has setup for Linux desktop for observer use in elixir, which also applies to Erlang
   https://github.com/c0b/docker-elixir/wiki/use-observer
2. dirty scheduler is enabled in Erlang 19 images;

Read from https://github.com/erlang/otp/releases for each tag description as release annoucement.

### Design

1. the standard variant `erlang:19` `erlang:18`, `erlang:17`, builds from source code,
   based on [buildpack-deps:jessie](https://hub.docker.com/_/buildpack-deps/);
   it covered gcc compiler and some popular -dev packages, for those erlang port drivers written in C; while it doesn't have java compiler so jinterface doesn't compile, wxwidgets depends on some gl/gtk headers/lib also doesn't compile; here is assuming that to run GUI applications in docker is not popular, so here can save some space; jinterface is similar, the java dependencies are too fat, assuming demand to write java code for erlang applications is low;
2. the -onbuild variant for each erlang version, to utilize ONBUILD instruction from Dockerfile, those are for starters
3. the slim version is built from `debian:jessie` install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, to shrink image size;
4. rebar and rebar3 tool is bundled in `erlang:19` and `erlang:18` image, for `-onbuild` images to do something interesting;

### Sizes

```console
$ docker images |grep ^erlang
REPOSITORY TAG         IMAGE ID       CREATED          SIZE
erlang     19.0        abfb7f7bad3a   48 minutes ago   750.6 MB
erlang     19.0-slim   5aba9752dbd6   36 minutes ago   286.6 MB
erlang     18.3        d7ca420db287   21 minutes ago   749.8 MB
erlang     18.3-slim   cfeb2e9a2d9e   29 minutes ago   285.8 MB
erlang     17.8-slim   e1fd9f4c9328   7 weeks ago      285.6 MB
erlang     19.0-rc2    7c7178e1d074   8 weeks ago      759.4 MB
erlang     19.0-x32    a7bff53623ba   2 minutes ago    699.4 MB
erlang     19.0-rc0    448ce5129d08   7 minutes ago    742.5 MB
erlang     18.2        907bbcb7b07f   43 minutes ago   744.8 MB
erlang     18.2-slim   f4f63e4ef62d   27 hours ago     283.9 MB
erlang     17.5-slim   16948ef75f5f   43 hours ago     280.7 MB
erlang     17.5        d16f45f04f42   43 hours ago     740.2 MB
erlang     18.2-slim   8db47440816d   43 hours ago     283.9 MB
erlang     18.2-x32    fe555fc315ae   2 days ago       700.3 MB
erlang     18.1-slim   0d2ef515fa92   21 minutes ago   283.6 MB
erlang     18.1        57cd51bedc4b   35 minutes ago   742.9 MB
```

### Running

```console
$ docker run -it --rm erlang:19.0
Erlang/OTP 19 [erts-8.0.2] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V8.0.2  (abort with ^G)
1> uptime().
7 seconds
ok
2> application:which_applications().
[{stdlib,"ERTS  CXC 138 10","3.0.1"},
 {kernel,"ERTS  CXC 138 10","5.0.1"}]
3>            # use Ctrl-G to call out shell menu to quit
User switch command
 --> q
$ docker run -it --rm erlang:19.0 /bin/bash
root@cdf69caa9ff9:/# ls /usr/local/lib/erlang/lib/
asn1-4.0.3             dialyzer-3.0.1     inets-6.3.2       reltool-0.7.1
common_test-1.12.2     diameter-1.12      kernel-5.0.1      runtime_tools-1.10
compiler-7.0.1         edoc-0.7.19        megaco-3.18.1     sasl-3.0
cosEvent-2.2.1         eldap-1.2.2        mnesia-4.14       snmp-5.2.3
cosEventDomain-1.2.1   erl_docgen-0.5     observer-2.2.1    ssh-4.3.1
cosFileTransfer-1.2.1  erl_interface-3.9  odbc-2.11.2       ssl-8.0.1
cosNotification-1.2.2  erts-8.0.2         orber-3.8.2       stdlib-3.0.1
cosProperty-1.2.1      et-1.6             os_mon-2.4.1      syntax_tools-2.0
cosTime-1.2.2          eunit-2.3          otp_mibs-1.1.1    tools-2.8.5
cosTransactions-1.3.2  gs-1.6.1           parsetools-2.1.2  typer-0.9.11
crypto-3.7             hipe-3.15.1        percept-0.9       wx-1.7
debugger-4.2           ic-4.4.1           public_key-1.2    xmerl-1.3.11
root@cdf69caa9ff9:/# ls /usr/local/lib/erlang/lib/ |wc -l
48
```

The official release 19 https://github.com/erlang/otp/tree/maint-19/lib has 48 libs, while here by default it provided 47 of them (plus erts-8.0.2 from erlang itself), except jinterface, because to build that one would pull all jdk dependencies and make this image too fat, it's just avoided here; if you really need that to write code in java and interface into erlang code, you may create an issue for this project.