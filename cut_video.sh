#!/usr/bin/env bash
# Tải video YouTube (kèm phụ đề tiếng Anh) và cắt thành các phần, mỗi phần dưới 60 phút.
# Cách dùng:
#   ./cut_video.sh <youtube_url> [so_phan]
#   so_phan: mặc định tự tính (tối thiểu 2, mỗi phần tối đa ~58 phút)
# Yêu cầu: yt-dlp, ffmpeg
set -euo pipefail

url="${1:?Usage: $0 <youtube_url> [parts]}"
parts="${2:-}"
max_len=3480 # 58 phút, chừa khoảng an toàn cho giới hạn 60 phút
out_dir="output"
mkdir -p "$out_dir"

yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/b" --merge-output-format mp4 \
  --write-subs --write-auto-subs --sub-langs "en.*,en" --convert-subs srt \
  -o "$out_dir/source.%(ext)s" "$url"
src="$out_dir/source.mp4"
srt=$(ls "$out_dir"/source*.srt 2>/dev/null | head -n1 || true)

duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$src")
if [[ -z "$parts" ]]; then
  parts=$(awk -v d="$duration" -v m="$max_len" 'BEGIN { n = int((d + m - 1) / m); if (n < 2) n = 2; print n }')
fi
len=$(awk -v d="$duration" -v n="$parts" 'BEGIN { printf "%.3f", d / n }')
echo "Duration: ${duration}s -> $parts parts of ${len}s"

for ((i = 0; i < parts; i++)); do
  start=$(awk -v l="$len" -v i="$i" 'BEGIN { printf "%.3f", l * i }')
  n=$((i + 1))
  # Re-encode để điểm cắt chính xác (không bị lệch keyframe).
  ffmpeg -y -ss "$start" -i "$src" -t "$len" -c:v libx264 -preset fast -crf 20 -c:a aac "$out_dir/part$n.mp4"
  if [[ -n "$srt" ]]; then
    ffmpeg -y -itsoffset "-$start" -i "$srt" -ss 0 -t "$len" "$out_dir/part$n.srt"
  fi
done

echo "Done:"; ls -1 "$out_dir"/part*
