# Cut-video

Cắt một video YouTube dài thành các phần **dưới 60 phút** (mặc định ít nhất 2 phần), kèm phụ đề tiếng Anh đã cắt theo từng phần, để luyện shadowing.

```bash
pip install yt-dlp            # cần thêm ffmpeg
./cut_video.sh "https://www.youtube.com/watch?v=QSAEVpv9SAM"      # tự tính số phần
./cut_video.sh "https://www.youtube.com/watch?v=QSAEVpv9SAM" 3    # chia thành 3 phần
```

Kết quả trong `output/`: `part1.mp4`, `part1.srt`, `part2.mp4`, `part2.srt`, ...

## Đưa lên YouTube để shadowing

1. YouTube Studio → **Create → Upload videos** → chọn `part1.mp4`.
2. Ở bước **Visibility** chọn **Unlisted** (không chọn Private — Private không nhúng được vào trang khác).
3. Mục **Subtitles** → **Add language: English** → **Upload file** → chọn `part1.srt` (*With timing*).
4. Lặp lại cho `part2`.
5. Chờ YouTube xử lý xong, copy link từng video và dán vào trang shadowing.
