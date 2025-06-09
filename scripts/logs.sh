#!/bin/bash
echo "📋 OpenMemory MCP Logs:"
docker-compose -f .coolify/docker-compose.yml logs -f "${1:-}"
