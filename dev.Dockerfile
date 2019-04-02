FROM swift:4.2
RUN apt-get -qq update && apt-get -q -y install \
  libicu55 libxml2 libbsd0 libcurl3 libatomic1  \
  tzdata \
    && rm -r /var/lib/apt/lists/*
WORKDIR /app