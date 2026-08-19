FROM rust:1.86-bookworm AS builder

WORKDIR /app

COPY nimaproxy/Cargo.toml nimaproxy/Cargo.lock ./nimaproxy/

WORKDIR /app/nimaproxy

RUN cargo build --release

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/nimaproxy/target/release/nimaproxy /usr/local/bin/nimaproxy

EXPOSE 10000

CMD ["/usr/local/bin/nimaproxy", "--config", "/etc/secrets/nimaproxy.toml"]
