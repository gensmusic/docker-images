FROM gensmusic/ffmpeg:debian-dev as builder

FROM  gensmusic/ffmpeg:debian-runtime-deps
COPY --from=builder /root/ffmpeg_build/bin/ffmpeg /usr/local/bin/
COPY --from=builder /root/ffmpeg_build/bin/ffprobe /usr/local/bin/

