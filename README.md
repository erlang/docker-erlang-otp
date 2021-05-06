# The Official Erlang OTP images

[![dockeri.co](http://dockeri.co/image/_/erlang)](https://hub.docker.com/_/erlang/)

[![Docker Stars](https://img.shields.io/docker/stars/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Docker Pulls](https://img.shields.io/docker/pulls/_/erlang.svg?style=flat-square)](https://hub.docker.com/_/erlang/)
[![Image Layers](https://images.microbadger.com/badges/image/erlang.svg)](https://microbadger.com/images/erlang "Get your own image badge on microbadger.com")

[![Build Status](https://img.shields.io/github/workflow/status/erlang/docker-erlang-otp/CI?style=square)](https://github.com/erlang/docker-erlang-otp/actions/workflows/main.yml)

This is used as docker base image for Erlang OTP.
The goal is to provide images for a few last erlang releases (currently 23/ 22/ 21/ 20 / 19 / 18), in close to full feature Erlang OTP, and relatively slim images. Support to 17, R16 and R15 are provided in this repo on a best-effort basis, and not part of official-image effort in docker-library/official-images#1075 .

### use the Erlang 23

here is providing the latest Erlang 23 image; you may pull from official-images or build it locally:

```console
$ docker build -t erlang:23.0 ./23
[...]
➸ docker run -it --rm erlang:23.0
Erlang/OTP 23 [erts-11.0.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Eshell V11.0.3  (abort with ^G)
1> erlang:system_info(otp_release).
"23"
2> os:getenv().
["PROGNAME=erl","ROOTDIR=/usr/local/lib/erlang",
 "TERM=xterm","REBAR3_VERSION=3.14.4","REBAR_VERSION=2.6.4",
 "PWD=/","HOSTNAME=bc9486c9549b","OTP_VERSION=23.0.3",
 "PATH=/usr/local/lib/erlang/erts-11.0.3/bin:/usr/local/lib/erlang/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
 "EMU=beam","HOME=/root",
 "BINDIR=/usr/local/lib/erlang/erts-11.0.3/bin"]
3> 'hello_юникод_世界'.                                   % Erlang20 now support unicode in atom
'hello_юникод_世界'
4> try 1/0 catch C:R:Stacktrace -> logger:error("caught: ~tp~n", [{C,R,Stacktrace}]) end. %% Erlang 21 now has new API for logging, logger
=ERROR REPORT==== 20-Jun-2018::07:23:13.384474 ===
caught: {error,badarith,
               [{erlang,'/',[1,0],[]},
                {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,681}]},
                {erl_eval,try_clauses,8,[{file,"erl_eval.erl"},{line,911}]},
                {shell,exprs,7,[{file,"shell.erl"},{line,686}]},
                {shell,eval_exprs,7,[{file,"shell.erl"},{line,642}]},
                {shell,eval_loop,3,[{file,"shell.erl"},{line,627}]}]}
5> h(lists,foldl). %% Erlang 23 now has the documentation in the shell

  -spec foldl(Fun, Acc0, List) -> Acc1
                 when
                     Fun :: fun((Elem :: T, AccIn) -> AccOut),
                     Acc0 :: term(),
                     Acc1 :: term(),
                     AccIn :: term(),
                     AccOut :: term(),
                     List :: [T],
                     T :: term().

  Calls Fun(Elem, AccIn) on successive elements A of List,
  starting with AccIn == Acc0. Fun/2 must return a new
  accumulator, which is passed to the next call. The function
  returns the final value of the accumulator. Acc0 is returned if
  the list is empty.

  Example:

    > lists:foldl(fun(X, Sum) -> X + Sum end, 0, [1,2,3,4,5]).
    15
    > lists:foldl(fun(X, Prod) -> X * Prod end, 1, [1,2,3,4,5]).
    120

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

1. the standard variant `erlang:23` and `erlang:22` builds from source code, based on [`buildpack-deps:buster`](https://hub.docker.com/_/buildpack-deps/); (releases before `erlang:22` builds using [`buildpack-deps:stretch`](https://hub.docker.com/_/buildpack-deps/))
   `erlang:23.1` and later contains documentation that can be accessed in the shell
   it covered gcc compiler and some popular -dev packages, for those erlang port drivers written in C; while it doesn't have java compiler so jinterface doesn't compile, assuming demand to write java code for erlang applications is low;
3. the slim version is built from `debian:buster` install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, to shrink image size;
4. the alpine version is built from last alpine stable image, install building tools (compilers & -dev packages) on the fly and uninstall after compilation finished, also removed src/\*.erl include/\*.hrl / all docs (include man info) / examples / static archives / build and unittest tools, and strip the ELF binaries, to get a really slim image, ideally smaller than 20MB;
5. rebar and rebar3 tool is bundled in `erlang:23`, `erlang:22`, `erlang:21`, `erlang:20`, `erlang:19` and `erlang:18` image;

### Sizes

```console
$ docker images --filter=reference='erlang:*'
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
erlang              23.0                37433d089268        13 days ago         1.22GB
erlang              23.0-slim           372b42eed86b        2 weeks ago         257MB
erlang              23.0-alpine         db7cf4f98f42        4 weeks ago         68.7MB
erlang              22.3                c77ded78275c        13 hours ago        1.22GB
erlang              22.3-slim           ca5dbe8a4a46        13 hours ago        255MB
erlang              22.3-alpine         661e530efb37        13 hours ago        68.9MB
erlang              21.3                537ac956d5d6        13 days ago         1.07GB
erlang              21.3-slim           5ffbb00d3118        2 weeks ago         251MB
erlang              21.3-alpine         263294b72a1f        2 weeks ago         73.4MB
erlang              20.3                82c4e39617a9        13 days ago         1.07GB
erlang              20.3-slim           3e123645dc80        2 weeks ago         259MB
erlang              20.3-alpine         78861bbea4a0        3 months ago        77.3MB
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
