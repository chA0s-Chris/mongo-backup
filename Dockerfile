FROM ubuntu:22.04 AS builder

# install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        ca-certificates

# add MongoDB repository
RUN curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
    gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg && \
    echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-8.0.list

# install MongoDB database tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends mongodb-database-tools && \
    rm -rf /var/lib/apt/lists/*

# install chisel
RUN curl -fsSL https://github.com/canonical/chisel/releases/download/v1.0.0/chisel_v1.0.0_linux_amd64.tar.gz | \
    tar -xz -C /usr/local/bin

# use chisel to create a minimal filesystem
RUN mkdir /chiseled && \
   /usr/local/bin/chisel cut --release ubuntu-24.04 --root /chiseled \
		base-files_base \
		base-files_release-info \
		ca-certificates_data \
		libc6_libs \
		libssl3t64_libs \
		libcurl4t64_libs \
		liblzma5_libs \
		libsnappy1v5_libs \
		zlib1g_libs

# copy mongodump to chiseled filesystem
RUN cp /usr/bin/mongodump /chiseled/usr/bin/

####################################################################
FROM scratch

COPY --from=builder /chiseled /

ENTRYPOINT ["/usr/bin/mongodump", "--version"]
