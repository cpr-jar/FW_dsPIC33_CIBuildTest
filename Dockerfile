# This file was generated by the CI/CD Wizard version 1.0.421.
# See the user guide for information on how to customize and use this file.

FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

USER root
RUN dpkg --add-architecture i386 \
 && apt-get update -yq \
 && apt-get install -yq --no-install-recommends \
    ca-certificates \
    curl \
    make \
    unzip \
    procps \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Download and install MPLAB X IDE version 6.00
ENV MPLABX_VERSION 6.00

RUN curl -fSL -A "Mozilla/4.0" -o /tmp/mplabx-installer.tar \
         "https://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v${MPLABX_VERSION}-linux-installer.tar" \
 && tar xf /tmp/mplabx-installer.tar -C /tmp/ && rm /tmp/mplabx-installer.tar  \
 && USER=root ./tmp/MPLABX-v${MPLABX_VERSION}-linux-installer.sh --nox11 \
    -- --unattendedmodeui none --mode unattended \
 && rm ./tmp/MPLABX-v${MPLABX_VERSION}-linux-installer.sh \
 && rm -rf /opt/microchip/mplabx/v${MPLABX_VERSION}/packs/Microchip/*_DFP \
 && rm -rf /opt/microchip/mplabx/v${MPLABX_VERSION}/mplab_platform/browser-lib
ENV PATH /opt/microchip/mplabx/v${MPLABX_VERSION}/mplab_platform/bin:$PATH
ENV PATH /opt/microchip/mplabx/v${MPLABX_VERSION}/mplab_platform/mplab_ipe:$PATH
ENV XCLM_PATH /opt/microchip/mplabx/v${MPLABX_VERSION}/mplab_platform/bin/xclm

ENV TOOLCHAIN xc16
ENV TOOLCHAIN_VERSION 2.00

# Download and install toolchain
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/${TOOLCHAIN}.run \
    "https://ww1.microchip.com/downloads/aemDocuments/documents/DEV/ProductDocuments/SoftwareTools/${TOOLCHAIN}-v${TOOLCHAIN_VERSION}-full-install-linux64-installer.run" \
 && chmod a+x /tmp/${TOOLCHAIN}.run \
 && /tmp/${TOOLCHAIN}.run --mode unattended --unattendedmodeui none \
    --netservername localhost --LicenseType NetworkMode \
 && rm /tmp/${TOOLCHAIN}.run
ENV PATH /opt/microchip/${TOOLCHAIN}/v${TOOLCHAIN_VERSION}/bin:$PATH

# DFPs needed for default configuration

# Download and install Microchip.dsPIC33E-GM-GP-MC-GU-MU_DFP.1.4.139
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/tmp-pack.atpack \
         "https://packs.download.microchip.com/Microchip.dsPIC33E-GM-GP-MC-GU-MU_DFP.1.4.139.atpack" \
 && mkdir -p /opt/microchip/mplabx/v${MPLABX_VERSION}/packs/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.4.139 \
 && unzip -o /tmp/tmp-pack.atpack -d /opt/microchip/mplabx/v${MPLABX_VERSION}/packs/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.4.139 \
 && rm /tmp/tmp-pack.atpack
ENV BUILD_CONFIGURATION default