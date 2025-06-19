# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
#FROM ghcr.io/ublue-os/bazzite:stable
FROM  ghcr.io/ublue-os/silverblue-main:sha256-d3ad3597ea09924a46225411ea2f163b1494fc399c814602bbd78730eb4630f2.sig

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
RUN rpm-ostree install gnome-kiosk gnome-kiosk-script-session qt5-qt3d \
   qt5-qtaccountsservice qt5-qtcharts qt5-qtconfiguration \
   qt5-qtconnectivity qt5-qtdatavis3d qt5-qtfeedback qt5-qtgamepad \
   qt5-qtgraphicaleffects qt5-qtimageformats qt5-qtlocation \
   qt5-qtmultimedia qt5-qtnetworkauth qt5-qtquickcontrols \
   qt5-qtquickcontrols2 qt5-qtremoteobjects qt5-qtscript \
   qt5-qtscxml qt5-qtsensors qt5-qtserialbus qt5-qtserialport \
   qt5-qtspeech qt5-qtspeech-flite qt5-qtspeech-speechd qt5-qttools \
   qt5-qttools-libs-designer qt5-qttools-libs-designercomponents \
   qt5-qttools-libs-help qt5-qtvirtualkeyboard qt5-qtwebchannel \
   qt5-qtwebengine qt5-qtwebengine-freeworld qt5-qtwebkit \
   qt5-qtwebsockets qt5-qtwebview qt5ct qt5pas

## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
