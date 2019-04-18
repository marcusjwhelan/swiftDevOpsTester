# You can set the Swift version to what you need for your app. Versions can be found here: https://hub.docker.com/_/swift
FROM norionomura/swift:5.0 as builder

# For local build, add `--build-arg env=docker`
# In your application, you can use `Environment.custom(name: "docker")` to check if you're in this env
ARG env
ENV DEBIAN_FRONTEND=noninteractive
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main"
RUN apt-get update && apt-get upgrade -y && \
    apt-get dist-upgrade -y && apt-get -y install apt-utils && \
    apt-get -y install libicu55 tzdata libssl-dev pkg-config \
    && rm -r /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

# Production image
FROM ubuntu:18.04
ARG env
ENV DEBIAN_FRONTEND=noninteractive
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main"
RUN apt-get update && apt-get upgrade -y && \
    apt-get dist-upgrade -y && apt-get -y install apt-utils && \
    apt-get -y install libicu55 libxml2 libbsd0 libcurl3 libatomic1 \
    tzdata libssl-dev pkg-config \
    && rm -r /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /build/bin/Run .
COPY --from=builder /build/lib/* /usr/lib/

# Uncomment the next line if you need to load resources from the `Public` directory
#COPY --from=builder /app/Public ./Public

# Uncomment the next line if you are using Leaf
#COPY --from=builder /app/Resources ./Resources

ENV ENVIRONMENT=$env
ENV DEBIAN_FRONTEND teletype

EXPOSE 8080
ENTRYPOINT ./Run serve --env production -b 0.0.0.0
#ENTRYPOINT ./Run serve --env $ENVIRONMENT --hostname 0.0.0.0 --port 80
