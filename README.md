# About this Repo

[![Build Status](https://travis-ci.org/c0b/docker-erlang-otp.svg?branch=master)](https://travis-ci.org/c0b/docker-erlang-otp)

This is used as docker base image for Erlang OTP.
The goal is to provide images for a few last erlang releases (currently the last 4, one latest release for each of last four major version: 18, 17, R16, R15.), in close to full feature Erlang OTP, and relatively slim images;

### Design

1. the standard variant `erlang:18`, `erlang:17`, `erlang:R16`, `erlang:R15` builds from source code,
   based on [buildpack-deps:jessie](https://hub.docker.com/_/buildpack-deps/);
   it covered gcc compiler and some popular -dev packages, for port driver written in C; while it doesn't have java compiler so the odbc / jinterface doesn't compile, wxwidgets depends on some gl/gtk headers/lib also doesn't compile; I assume to run GUI applications in docker is not popular, so here we can save space; jinterface is similar, the java dependencies are too fat, I assume demand is low;
2. the -onbuild variant for each erlang version, to utilize ONBUILD instruction from Dockerfile, those are for starters
3. -esl variant is to pull erlang-solutions deb package to install on top of `debian:jessie`, results in relatively slim image, while I am trying to avoid install depended packages by wxwidgets / jinterface, reasons same as above.

### Sizes

```console
$ docker images |grep ^erlang
erlang     18.1-esl            138c797adec7        5 days ago          286.9 MB
erlang     18.1                27ad0fc44644        5 days ago          741.5 MB
erlang     R16B03-1            e0deec5e1e72        6 days ago          740.2 MB
erlang     18.0.3              52d4a7a4a281        6 days ago          743.7 MB
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
root@6d2c1ad52ae8:/# ls /usr/local/lib/erlang/lib/
asn1-4.0     cosProperty-1.2  edoc-0.7.17     gs-1.6    observer-2.1
 public_key-1.0.1 stdlib-2.6   xmerl-1.3.8 common_test-1.11
cosTime-1.2  eldap-1.2     hipe-3.13    orber-3.8    reltool-0.7
syntax_tools-1.7 compiler-6.0.1     cosTransactions-1.3
erl_docgen-0.4     ic-4.4    os_mon-2.4    runtime_tools-1.9.1
test_server-3.9 cosEvent-2.2     crypto-3.6.1  erl_interface-3.8
inets-6.0.1    ose-1.1    sasl-2.6 tools-2.8.1 cosEventDomain-1.2
debugger-4.1.1  erts-7.1     kernel-4.1     otp_mibs-1.1    snmp-5.2
typer-0.9.9 cosFileTransfer-1.2  dialyzer-2.8.1  et-1.5.1
megaco-3.18    parsetools-2.1  ssh-4.1 webtool-0.9 cosNotification-1.2
 diameter-1.11  eunit-2.2.11     mnesia-4.13.1  percept-0.8.11
ssl-7.1 wx-1.5
root@4cfd3172e8cc:/# ls /usr/local/lib/erlang/lib/ | wc -l
50
```

Check [Existing images for Erlang OTP](https://github.com/docker-library/official-images/pull/1075#issuecomment-144287252)

Latest Erlang OTP Releases: http://www.erlang.org/download.html

