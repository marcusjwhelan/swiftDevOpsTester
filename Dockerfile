# You can set the Swift version to what you need for your app. Versions can be found here: https://hub.docker.com/_/swift
FROM swift:4.2 as builder

# For local build, add `--build-arg env=docker`
# In your application, you can use `Environment.custom(name: "docker")` to check if you're in this env
ARG env
ENV DEBIAN_FRONTEND=noninteractive

#RUN apt-get -qq update && apt-get -q -y install \
#  libssl-dev pkg-config \
#  && rm -r /var/lib/apt/lists/*
WORKDIR /App
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin

# Production image
FROM ubuntu:18.04
ARG env
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && apt-get install -y \
  libxml2 libbsd0 libcurl3 libatomic1 libssl-dev \
  tzdata pkg-config \
  && rm -r /var/lib/apt/lists/*
WORKDIR /App
COPY --from=builder /build/bin/Run .
COPY --from=builder /build/lib/* /usr/lib/

# Uncomment the next line if you need to load resources from the `Public` directory
#COPY --from=builder /app/Public ./Public

# Uncomment the next line if you are using Leaf
#COPY --from=builder /app/Resources ./Resources

ENV ENVIRONMENT=$env
ENV DEBIAN_FRONTEND teletype

EXPOSE 8080
# CMD ["./Run"]
ENTRYPOINT ./Run serve -e prod -b 0.0.0.0
#ENTRYPOINT ./Run serve --env $ENVIRONMENT --hostname 0.0.0.0 --port 80
