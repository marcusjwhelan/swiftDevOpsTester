FROM swift:4.2 as builder

RUN apt-get -q update && apt-get -q install -y \
    libxml2 libbsd0 libcurl3 libatomic1 libssl-dev \
    tzdata pkg-config apt-utils \
  && rm -r /var/lib/apt/lists/*

WORKDIR /app/
COPY . .

# 1) copy Swift libraries
#RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib

# 2) build project - debug modbuilde
# RUN swift build && mv `swift  --show-bin-path` /build/bin

# 2) build project - production
#RUN swift build --verbose -c release && mv `swift build -c release --show-bin-path` /build/bin