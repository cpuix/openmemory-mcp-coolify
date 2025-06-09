#!/bin/bash
echo "🛑 OpenMemory MCP durduruluyor..."
docker-compose -f .coolify/docker-compose.yml down
echo "✅ Durduruldu"
