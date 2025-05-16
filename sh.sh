#!/bin/bash

CONFIG="/usr/local/etc/v2ray/config.json"

if [[ ! -f "$CONFIG" ]]; then
  echo "❌ Config tidak ditemukan di $CONFIG"
  exit 1
fi

echo "📄 Menampilkan konfigurasi V2Ray:"
echo ""

PORT=$(jq -r '.inbounds[0].port' "$CONFIG")
LISTEN=$(jq -r '.inbounds[0].listen // "0.0.0.0"' "$CONFIG")
PATH=$(jq -r '.inbounds[0].streamSettings.wsSettings.path // empty' "$CONFIG")

echo "🔹 Port   : $PORT"
echo "🔹 Listen : $LISTEN"
echo "🔹 Path   : ${PATH:-<tidak ada>}"

echo ""
echo "✅ Status:"
ss -tunlp | grep ":$PORT" || echo "❌ Port $PORT belum aktif"

echo ""
if [[ "$LISTEN" != "127.0.0.1" ]]; then
  echo "⚠️  Disarankan listen = 127.0.0.1 untuk koneksi lokal dengan wsproxy"
fi

if [[ -z "$PATH" ]]; then
  echo "⚠️  Tidak ada path WebSocket terdeteksi! Tambahkan misalnya: \"/v2ray\""
else
  echo "✅ WebSocket path terdeteksi: $PATH"
fi

echo ""
echo "🔁 Jika kamu ingin auto-sesuaikan config agar listen 127.0.0.1 port 8080 path /v2ray, ketik: setup-v2ray-ws"
