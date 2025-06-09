#!/bin/bash
echo "📊 OpenMemory MCP Status:"
echo "========================="
docker-compose -f .coolify/docker-compose.yml ps
echo ""
echo "🔍 Health Checks:"
echo "API: $(curl -s -o /dev/null -w '%{http_code}' https://${DOMAIN:-localhost}/api/health)"
echo "UI: $(curl -s -o /dev/null -w '%{http_code}' https://${DOMAIN:-localhost}/)"
