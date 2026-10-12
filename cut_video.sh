#!/usr/bin/env bash
# Tải video YouTube và cắt thành 2 phần bằng nhau (hoặc tại mốc thời gian tuỳ chọn).
# Cách dùng:
#   ./cut_video.sh <youtube_url> [split_point]
#   split_point: số giây hoặc HH:MM:SS (mặc định: giữa video)
# Yêu cầu: yt-dlp, ffmpeg
set -euo pipefail

url="${1:?Usage: $0 <youtube_url> [split_point]}"
split="${2:-}"
out_dir="output"
mkdir -p "$out_dir"

yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/b" --merge-output-format mp4 \
  -o "$out_dir/source.%(ext)s" "$url"
src="$out_dir/source.mp4"

duration=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$src")
if [[ -z "$split" ]]; then
  split=$(awk -v d="$duration" 'BEGIN { printf "%.3f", d / 2 }')
fi
echo "Duration: ${duration}s, split at: ${split}"

# Re-encode để điểm cắt chính xác (không bị lệch keyframe).
ffmpeg -y -i "$src" -t "$split" -c:v libx264 -preset fast -crf 20 -c:a aac "$out_dir/part1.mp4"
ffmpeg -y -ss "$split" -i "$src" -c:v libx264 -preset fast -crf 20 -c:a aac "$out_dir/part2.mp4"

echo "Done: $out_dir/part1.mp4, $out_dir/part2.mp4"
