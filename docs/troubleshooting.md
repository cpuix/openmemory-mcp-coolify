# OpenMemory MCP Troubleshooting Guide

## Common Issues and Solutions

### 1. Services Not Starting

#### Symptoms
- Containers exit immediately
- Health checks fail
- Services stuck in "Starting" state

#### Solutions

**Check Environment Variables**
```bash
# Verify required variables are set
grep -E "OPENAI_API_KEY|DOMAIN" .env

# Test OpenAI API key
curl -H "Authorization: Bearer $OPENAI_API_KEY" https://api.openai.com/v1/models
```

**Check Docker Resources**
```bash
# Verify Docker is running
docker info

# Check available resources
docker system df
docker system prune  # Clean up if needed
```

**Review Service Logs**
```bash
./scripts/logs.sh api
./scripts/logs.sh qdrant
./scripts/logs.sh ui
```

### 2. API Health Check Failures

#### Symptoms
- `/health` endpoint returns 500 or timeout
- API container restarts frequently
- MCP connections fail

#### Solutions

**Check OpenAI Connectivity**
```bash
# Test from API container
docker exec openmemory-api curl -H "Authorization: Bearer $OPENAI_API_KEY" https://api.openai.com/v1/models
```

**Verify Qdrant Connection**
```bash
# Check Qdrant health
curl http://localhost:6333/health

# Check from API container
docker exec openmemory-api curl http://qdrant:6333/health
```

**Check API Logs**
```bash
./scripts/logs.sh api | grep -E "ERROR|CRITICAL"
```

### 3. UI Not Accessible

#### Symptoms
- Dashboard doesn't load
- 502/503 errors
- SSL certificate issues

#### Solutions

**Check Domain Configuration**
```bash
# Verify DNS resolution
nslookup your-domain.com

# Test SSL certificate
curl -I https://your-domain.com
```

**Check Traefik Routing**
```bash
# Verify labels in docker-compose
docker inspect openmemory-ui | grep -A 20 Labels
```

**Test Local Access**
```bash
# Bypass proxy
curl http://localhost:3000
```

### 4. MCP Connection Issues

#### Symptoms
- MCP clients can't connect
- SSE connection drops
- "Connection refused" errors

#### Solutions

**Verify MCP Endpoint**
```bash
# Test SSE endpoint
curl -H "Accept: text/event-stream" https://your-domain.com/mcp/test/sse/test_user
```

**Check Long Connection Settings**
```bash
# Verify Traefik timeout settings
docker inspect openmemory-api | grep -A 5 "traefik.http.middlewares"
```

### 5. Memory/Storage Issues

#### Symptoms
- Out of disk space errors
- Slow performance
- Qdrant indexing failures

#### Solutions

**Check Disk Usage**
```bash
# Check overall disk usage
df -h

# Check Docker volumes
docker system df

# Check specific volumes
docker volume ls
docker volume inspect openmemory_qdrant_data
```

**Clean Up Storage**
```bash
# Clean Docker cache
docker system prune -a

# Remove old backups
find backups/ -type d -mtime +7 -exec rm -rf {} \;

# Optimize Qdrant database
docker-compose -f .coolify/docker-compose.yml restart qdrant
```

### 6. Performance Issues

#### Symptoms
- Slow response times
- High CPU/memory usage
- Timeout errors

#### Solutions

**Monitor Resource Usage**
```bash
# Check container resources
docker stats

# Check specific service
docker stats openmemory-api openmemory-qdrant
```

**Optimize Configuration**
```bash
# Increase memory limits
# Edit .env file:
MAX_MEMORY_SIZE=2000
EMBEDDING_MODEL=text-embedding-3-small

# Restart services
./scripts/deploy.sh
```

## Diagnostic Commands

### Health Check Script

```bash
#!/bin/bash
echo "🔍 OpenMemory MCP Diagnostic Report"
echo "=================================="

# Service status
echo "📊 Service Status:"
docker-compose -f .coolify/docker-compose.yml ps

# Health checks
echo -e "\n🏥 Health Checks:"
echo "API: $(curl -s -o /dev/null -w '%{http_code}' https://$DOMAIN/api/health)"
echo "UI: $(curl -s -o /dev/null -w '%{http_code}' https://$DOMAIN/)"
echo "Qdrant: $(curl -s -o /dev/null -w '%{http_code}' http://localhost:6333/health)"

# Resource usage
echo -e "\n💻 Resource Usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Disk usage
echo -e "\n💾 Disk Usage:"
df -h | grep -E "/$|docker"

# Recent errors
echo -e "\n❌ Recent Errors:"
docker-compose -f .coolify/docker-compose.yml logs --tail=50 | grep -i error
```

### Log Analysis

```bash
# Find specific errors
./scripts/logs.sh api | grep -E "ERROR|CRITICAL|FATAL"

# Monitor real-time logs
./scripts/logs.sh | grep -E "$(date '+%Y-%m-%d')"

# Check startup sequence
./scripts/logs.sh | grep -E "Starting|Ready|Listening"
```

## Getting Help

### Debug Information to Collect

1. **System Information**
   ```bash
   uname -a
   docker --version
   docker-compose --version
   ```

2. **Service Configuration**
   ```bash
   cat .env
   docker-compose -f .coolify/docker-compose.yml config
   ```

3. **Error Logs**
   ```bash
   ./scripts/logs.sh > debug-logs.txt
   ```

4. **Resource Usage**
   ```bash
   docker stats --no-stream > resource-usage.txt
   ```

### Support Channels

- 📖 [Documentation](../README.md)
- 🐛 [GitHub Issues](https://github.com/yourusername/openmemory-mcp-coolify/issues)
- 💬 [GitHub Discussions](https://github.com/yourusername/openmemory-mcp-coolify/discussions)
- 📧 [Email Support](mailto:support@yourdomain.com)

### Before Reporting Issues

Please include:

1. OpenMemory MCP version
2. Operating system and Docker version
3. Complete error logs
4. Steps to reproduce the issue
5. Environment configuration (without sensitive data)

## Emergency Procedures

### Complete Reset

```bash
# Stop all services
./scripts/stop.sh

# Remove all data (⚠️ THIS WILL DELETE ALL MEMORIES)
sudo rm -rf data/ logs/

# Recreate directories
mkdir -p data/{qdrant,api} logs
chmod -R 755 data logs

# Restart services
./scripts/deploy.sh
```

### Rollback to Previous Version

```bash
# Stop current deployment
./scripts/stop.sh

# Restore from backup
BACKUP_DATE="20241209_143000"  # Replace with your backup date
cp -r backups/$BACKUP_DATE/data/* data/
cp backups/$BACKUP_DATE/.env .env

# Restart services
./scripts/deploy.sh
```

### Data Recovery

```bash
# Check if data exists
ls -la data/qdrant/
ls -la data/api/

# Recover from Docker volumes
docker run --rm -v openmemory_qdrant_data:/source -v $(pwd)/data/qdrant:/backup alpine cp -R /source/* /backup/

# Verify data integrity
./scripts/status.sh
```
