FROM swift:4.2 as builder

RUN apt-get -q update && apt-get -q install -y \
    apt-utils libxml2 libbsd0 libcurl3 libatomic1 libssl-dev \
    tzdata pkg-config libcurl4-doc libcurl3-dbg libidn11-dev \
    libkrb5-dev libldap2-dev librtmp-dev \
  && rm -r /var/lib/apt/lists/*

EXPOSE 8080

WORKDIR /app/
COPY . .

CMD ["swift", "build", "&&", "swift", "run", "Run", "serve", "-b", "0.0.0.0"]
# 1) copy Swift libraries
#RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib

# 2) build project - debug modbuilde
# RUN swift build && mv `swift  --show-bin-path` /build/bin

# 2) build project - production
#RUN swift build --verbose -c release && mv `swift build -c release --show-bin-path` /build/bin