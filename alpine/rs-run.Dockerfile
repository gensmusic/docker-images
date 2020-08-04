FROM alpine:3.12.0

# used as a runtime image for rust
RUN apk --no-cache add ca-certificates