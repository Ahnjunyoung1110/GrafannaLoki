#!/bin/sh
set -e

LOG_FILE="/app/cli.txt"
ANALYSIS_FILE="/app/analysis.txt"
TMP_DIR="/app/tmp_chunks"
CHUNK_SIZE=200  # 줄 수 기준. 필요시 조정

mkdir -p "$TMP_DIR"
> "$ANALYSIS_FILE"

# 환경 변수 확인
if [ -z "$GEMINI_API_KEY" ]; then
  echo "❌ GEMINI_API_KEY 환경 변수가 필요합니다."
  exit 1
fi

# 로그 파일 확인
if [ ! -f "$LOG_FILE" ]; then
  echo "❌ 로그 파일이 없습니다: $LOG_FILE"
  exit 1
fi
gemini -d -p "You are a senior site‑reliability engineer and forensic log analyst hired at great expense to quickly pinpoint production issues. 
Please read the following log excerpt, identify the most probable root cause(s), and suggest precise next‑step investigations or fixes. 
Use crisp bullet points, group findings by theme (e.g., network, DB, app logic). 
If extra context would meaningfully improve accuracy, list the exact data you’d request. And finally, translate your answer into korean. Do not print your english answer" > "$ANALYSIS_FILE"
echo "🚀 Gemini CLI 시작: $GEMINI_MODEL"

echo "🚀 로그를 분할하여 분석 시작..."
sleep 15


# 로그 분할
split -l $CHUNK_SIZE "$LOG_FILE" "$TMP_DIR/chunk_"

count=1
# Each chunk analysis
for chunk in "$TMP_DIR"/chunk_*; do
  echo "🧠 Analyzing: $chunk"
  gemini -d -p "This is a $count log file chunk. Please analyze it and provide insights.Please give a Korean-only response. Group by theme (network, DB, etc). Do not reply in English." \
  < "$chunk" >> "$ANALYSIS_FILE"
  printf "\n------------------------\n" >> "$ANALYSIS_FILE"
  count=$((count + 1))
done

gemini -p "Please summarize the analysis in a concise manner, focusing on the most critical findings and next steps. Provide a Korean-only response." \ < "$ANALYSIS_FILE" >> "$ANALYSIS_FILE"

echo "✅ 분석 완료: $ANALYSIS_FILE"
