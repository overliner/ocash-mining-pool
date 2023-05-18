FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine3.14

WORKDIR /tmp/

# ADD \
# https://github.com/oliverw/miningcore/archive/v72.tar.gz \
# .
#
# RUN \
# apk add --no-cache build-base cmake boost-dev libsodium-dev libzmq openssl-dev pkgconfig \
# && tar -xvf v72.tar.gz \
# && cd miningcore-72/src/Miningcore/ \
# && dotnet publish -c Release --framework net6.0 -o ../../build/ \
# && mkdir /usr/local/miningcore/ \
# && cd ../../ \
# && mv build/* /usr/local/miningcore/ \
# && cd ../ \
# && rm -r * \
# && apk del build-base cmake boost-dev libsodium-dev libzmq openssl-dev pkgconfig

COPY miningcore.patch ./miningcore.patch

RUN \
apk add --no-cache git build-base cmake boost-dev libsodium-dev libzmq openssl-dev pkgconfig \
&& git clone https://github.com/oliverw/miningcore.git \
&& cd miningcore \
&& git checkout v74 \
&& git apply ../miningcore.patch \
&& cd src/Miningcore/ \
&& dotnet publish -c Release --framework net6.0 -o ../../build/ \
&& mkdir /usr/local/miningcore/ \
&& cd ../../ \
&& mv build/* /usr/local/miningcore/ \
&& cd ../ \
&& rm -r * \
&& apk del git build-base cmake boost-dev libsodium-dev libzmq openssl-dev pkgconfig


FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine3.14

# LABEL maintainer="Overline"
# LABEL description=""

COPY --from=0 /usr/local/miningcore/ /usr/local/miningcore/

RUN \
apk add --no-cache boost-date_time boost-system openssl

RUN mkdir -p /usr/local/miningcore-data

# VOLUME ["/mnt/miningcore/"]

ENTRYPOINT ["dotnet", "/usr/local/miningcore/Miningcore.dll"]
CMD ["--help"]
