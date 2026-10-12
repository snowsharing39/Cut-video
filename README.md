# Cut-video

Cắt một video YouTube thành 2 video ngắn hơn.

```bash
pip install yt-dlp            # cần thêm ffmpeg
./cut_video.sh "https://www.youtube.com/watch?v=QSAEVpv9SAM"            # cắt đôi
./cut_video.sh "https://www.youtube.com/watch?v=QSAEVpv9SAM" 00:15:56   # cắt tại 15:56
```

Kết quả: `output/part1.mp4` và `output/part2.mp4`.
