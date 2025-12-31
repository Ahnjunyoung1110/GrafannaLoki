FROM node:18-alpine

# 기본 설정
WORKDIR /app
ENV GEMINI_API_KEY=AIzaSyAZDqo4AIr8rPlecNwZHmKea8AQ11Pa0Wo
ENV GEMINI_MODEL="gemini-2.5-pro"
COPY . .

# Gemini CLI 설치
RUN npm install -g @google/gemini-cli

# 실행 스크립트 복사
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# CMD ["/bin/sh", "-c", "/app/entrypoint.sh && tail -f /dev/null"]
CMD ["tail", "-f", "/dev/null"]
