# About this Repo

[![Build Status](https://travis-ci.org/c0b/docker-erlang-otp.svg?branch=master)](https://travis-ci.org/c0b/docker-erlang-otp)

This is used as docker base image for Erlang OTP.
The goal is to provide images for a few last erlang releases (currently 18 / 17), in close to full feature Erlang OTP, and relatively slim images. Support to R16 and R15 are provided in this repo on a best-effort basis, and not part of official-image effort in docker-library/official-images#1075 .

### Design

1. the standard variant `erlang:18`, `erlang:17`, builds from source code,
   based on [buildpack-deps:jessie](https://hub.docker.com/_/buildpack-deps/);
   it covered gcc compiler and some popular -dev packages, for those erlang port drivers written in C; while it doesn't have java compiler so jinterface doesn't compile, wxwidgets depends on some gl/gtk headers/lib also doesn't compile; I assume to run GUI applications in docker is not popular, so here we can save some space; jinterface is similar, the java dependencies are too fat, I assume demand to write java code for erlang applications is low;
2. the -onbuild variant for each erlang version, to utilize ONBUILD instruction from Dockerfile, those are for starters
3. rebar tool is bundled in `erlang:18` image.

### Sizes

```console
$ docker images |grep ^erlang
erlang     18.1        05a80e15fadc   2 hours ago   742.9 MB
erlang     18.1-slim   fc08749128b9   2 hours ago   283.6 MB
erlang     17.5        7a34c8030ca7   2 hours ago   739.8 MB
erlang     17.5-slim   e4003d4f37e6   2 hours ago   280.7 MB
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
root@88f845c8c7af:/# ls /usr/local/lib/erlang/lib/ |wc -l
51
```
