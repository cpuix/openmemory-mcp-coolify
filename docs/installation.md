# OpenMemory MCP Installation Guide

## Prerequisites

- Docker & Docker Compose
- OpenAI API Key
- Domain name (optional)
- Coolify instance

## Quick Installation

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/openmemory-mcp-coolify.git
cd openmemory-mcp-coolify
```

### 2. Set Environment Variables

```bash
export OPENAI_API_KEY="your-openai-api-key"
export DOMAIN="memory.yourdomain.com"
```

### 3. Run Installer

```bash
chmod +x coolify-install.sh
./coolify-install.sh
```

## Manual Installation

### 1. Create Environment File

```bash
cp .env.example .env
# Edit .env with your configuration
```

### 2. Create Data Directories

```bash
mkdir -p data/{qdrant,api} logs
chmod -R 755 data logs
```

### 3. Deploy Services

```bash
docker-compose -f .coolify/docker-compose.yml up -d
```

## Coolify Deployment

### 1. Create Project

1. Go to Coolify dashboard
2. Create new project: "OpenMemory MCP"
3. Choose "Git Repository"
4. Set repository URL

### 2. Configure Environment

Set these environment variables in Coolify:

- `OPENAI_API_KEY`: Your OpenAI API key
- `DOMAIN`: Your domain name
- `APP_NAME`: openmemory

### 3. Set Docker Compose Path

- **Compose File**: `.coolify/docker-compose.yml`

### 4. Configure Domain

1. Add domain in Coolify
2. Enable SSL/TLS
3. Update DNS records

### 5. Deploy

Click "Deploy" button and monitor logs.

## Verification

### Health Checks

```bash
# API health
curl https://your-domain.com/api/health

# UI health
curl https://your-domain.com/

# Service status
./scripts/status.sh
```

### Expected Responses

- API: `{"status": "healthy"}`
- UI: HTML page loads
- All services: Green status

## Troubleshooting

### Common Issues

1. **Services not starting**
   - Check environment variables
   - Verify Docker permissions
   - Review logs: `./scripts/logs.sh`

2. **API health check fails**
   - Check OpenAI API key
   - Verify Qdrant connection
   - Check logs: `./scripts/logs.sh api`

3. **UI not accessible**
   - Check domain configuration
   - Verify SSL certificates
   - Check Traefik routing

### Log Analysis

```bash
# All services
./scripts/logs.sh

# Specific service
./scripts/logs.sh api
./scripts/logs.sh ui
./scripts/logs.sh qdrant
```

## Next Steps

1. Create username in dashboard
2. Configure MCP clients
3. Test memory functionality
4. Set up monitoring (optional)
