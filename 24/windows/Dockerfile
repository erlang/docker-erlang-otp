# Use a separate build and distribution base image because some variants of Windows (i.e.
# nanoserver) don't include the necessary dependencies to run the installer)
ARG BUILD_IMAGE=mcr.microsoft.com/windows:10.0.17763.2114
ARG FROM_IMAGE=${BUILD_IMAGE}

FROM $BUILD_IMAGE as build

# Use powershell, fail fast on errors
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG OTP_VERSION
ARG OTP_HASH

ADD https://github.com/erlang/otp/releases/download/OTP-${OTP_VERSION}/otp_win64_${OTP_VERSION}.exe ./otp-installer.exe

# Check installer integrity
RUN if ((Get-FileHash ".\otp-installer.exe" -Algorithm SHA256).Hash -ne $Env:OTP_HASH) { exit 1; }

FROM $FROM_IMAGE

ARG OTP_VERSION

COPY --from=build ["C:/otp-installer.exe", "C:/otp-installer.exe"]

# Run and cleanup the installer
RUN .\otp-installer.exe /S /w /v"/qn"; \
  del /f .\otp-installer.exe

# This is a workaround for nanoserver where not possible to set PATH using setx or similar
ENV PATH="C:\Windows\system32;C:\Windows;C:/Program Files/erl-${OTP_VERSION}/bin"

# werl.exe isn't suitable here so we just use plain erl.exe; see
# https://www.erlang.org/doc/man/werl.html
CMD [ "erl.exe" ]
