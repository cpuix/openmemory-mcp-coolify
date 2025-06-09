# OpenMemory MCP Configuration Guide

## Environment Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `OPENAI_API_KEY` | OpenAI API key for embeddings | `sk-...` |
| `DOMAIN` | Your domain name | `memory.example.com` |

### Optional Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `APP_NAME` | `openmemory` | Application name prefix |
| `LOG_LEVEL` | `INFO` | Logging level |
| `MAX_MEMORY_SIZE` | `1000` | Maximum memories |
| `EMBEDDING_MODEL` | `text-embedding-3-small` | OpenAI model |

## MCP Client Configuration

### Claude Desktop

Location: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "openmemory": {
      "transport": "sse",
      "url": "https://your-domain.com/mcp/claude/sse/YOUR_USERNAME"
    }
  }
}
```

### Cursor

Location: `~/.cursor/mcp_servers.json`

```json
{
  "mcpServers": {
    "openmemory": {
      "transport": "sse",
      "url": "https://your-domain.com/mcp/cursor/sse/YOUR_USERNAME"
    }
  }
}
```

### Windsurf

```json
{
  "mcpServers": {
    "openmemory": {
      "transport": "sse",
      "serverUrl": "https://your-domain.com/mcp/windsurf/sse/YOUR_USERNAME"
    }
  }
}
```

## Docker Configuration

### Volume Mappings

```yaml
volumes:
  - qdrant_data:/qdrant/storage    # Vector database
  - api_data:/app/data             # API data
  - api_logs:/app/logs             # Application logs
```

### Port Mappings

| Service | Internal Port | External Port | Description |
|---------|---------------|---------------|-------------|
| UI | 3000 | 80/443 | Web dashboard |
| API | 8765 | 80/443 | REST API & MCP |
| Qdrant | 6333 | - | Vector database |
| Redis | 6379 | - | Cache |

## SSL/TLS Configuration

### Automatic (Recommended)

Coolify handles SSL automatically with Let's Encrypt.

### Manual Configuration

1. Place certificates in `/etc/ssl/certs/`
2. Update Traefik configuration
3. Restart services

## Performance Tuning

### Memory Settings

```yaml
api:
  environment:
    - MAX_MEMORY_SIZE=5000        # Increase memory limit
    - EMBEDDING_MODEL=text-embedding-3-large  # Better quality
```

### Qdrant Optimization

```yaml
qdrant:
  environment:
    - QDRANT__STORAGE__PERFORMANCE__OPTIMIZERS=indexing
    - QDRANT__SERVICE__MAX_REQUEST_SIZE_MB=32
```

### Redis Caching

```yaml
redis:
  command: >
    redis-server 
    --maxmemory 512mb
    --maxmemory-policy allkeys-lru
```

## Security Configuration

### API Key Protection

- Store in environment variables only
- Use Coolify secrets management
- Never commit to Git

### Network Security

```yaml
networks:
  openmemory-network:
    driver: bridge
    internal: true  # Isolate from external networks
```

### CORS Configuration

```yaml
api:
  environment:
    - CORS_ORIGINS=https://yourdomain.com,https://app.yourdomain.com
```

## Monitoring Configuration

### Prometheus Metrics

Enable metrics collection:

```yaml
api:
  environment:
    - ENABLE_METRICS=true
  labels:
    - "prometheus.io/scrape=true"
    - "prometheus.io/port=8765"
```

### Health Check Intervals

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8765/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## Backup Configuration

### Automatic Backups

Set up cron job for regular backups:

```bash
# Add to crontab
0 2 * * * /path/to/openmemory-mcp-coolify/scripts/backup.sh
```

### Backup Retention

```bash
# Keep last 7 days of backups
find backups/ -type d -mtime +7 -exec rm -rf {} \;
```

## Advanced Configuration

### Custom API Endpoints

```yaml
api:
  environment:
    - CUSTOM_ENDPOINTS=true
    - WEBHOOK_URL=https://your-webhook.com
```

### Multi-User Setup

```yaml
api:
  environment:
    - MULTI_USER=true
    - USER_REGISTRATION=false
    - ADMIN_API_KEY=your-admin-key
```

### Load Balancing

For high availability, use multiple API instances:

```yaml
api:
  deploy:
    replicas: 3
  labels:
    - "traefik.http.services.api.loadbalancer.sticky.cookie=true"
```
