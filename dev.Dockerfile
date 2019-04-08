FROM swift:4.2 as builder

RUN apt-get -qq update && apt-get -q -y install \
  tzdata  postgresql postgresql-contrib \
  && rm -r /var/lib/apt/lists/*

WORKDIR /app/
COPY . .

# 1) copy Swift libraries
#RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib

# 2) build project - debug mode
# RUN swift build && mv `swift build --show-bin-path` /build/bin

# 2) build project - production
#RUN swift build --verbose -c release && mv `swift build -c release --show-bin-path` /build/bin