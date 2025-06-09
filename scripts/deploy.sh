#!/bin/bash
echo "🚀 OpenMemory MCP deployment başlatılıyor..."
docker-compose -f .coolify/docker-compose.yml up -d
echo "✅ Deployment tamamlandı!"
echo "📊 Dashboard: https://${DOMAIN:-localhost}"
echo "🔌 MCP Endpoint: https://${DOMAIN:-localhost}/mcp"
