<div align="center">

# 🧠 OpenMemory MCP - Coolify Edition

**Local-first AI Memory Layer with MCP Support**

[![Deploy to Coolify](https://img.shields.io/badge/Deploy-Coolify-blue?style=for-the-badge&logo=docker)](https://coolify.io)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue?style=for-the-badge&logo=docker)](https://docs.docker.com/compose/)
[![OpenAI](https://img.shields.io/badge/OpenAI-API-green?style=for-the-badge&logo=openai)](https://openai.com)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](LICENSE)

*Your memories, your control. Privacy-focused AI memory that works across any MCP-compatible client.*

[🚀 Quick Start](#-quick-start) • 
[📖 Documentation](#-documentation) • 
[🔌 MCP Setup](#-mcp-client-setup) • 
[🛠️ Development](#️-development)

</div>

---

## ✨ Features

- 🔒 **Privacy First** - All data stays on your server using official Mem0 setup
- 🌐 **Universal Memory** - Works with Claude, Cursor, Windsurf, and all MCP clients
- ⚡ **Lightning Fast** - Vector-based semantic search with Qdrant + PostgreSQL
- 🐳 **One-Click Deploy** - Uses Mem0's official easy setup script
- 🔄 **Auto-Deploy** - GitHub Actions integration for seamless updates
- 📊 **Built-in Dashboard** - Official Mem0 web UI for memory management
- 🏗️ **Production Ready** - Mem0's battle-tested architecture
- 📈 **Monitoring Ready** - Built-in health checks and logging

## 🚀 Quick Start

### Option 1: One-Click Coolify Deployment

```bash
# Clone and run the installer
git clone https://github.com/yourusername/openmemory-mcp-coolify.git
cd openmemory-mcp-coolify
chmod +x coolify-install.sh

# Set required environment variables
export OPENAI_API_KEY="your-openai-api-key"
export DOMAIN="memory.yourdomain.com"

# Run the installer
./coolify-install.sh
```

### Option 2: Manual Installation

```bash
# Clone repository
git clone https://github.com/yourusername/openmemory-mcp-coolify.git
cd openmemory-mcp-coolify

# Create environment file
cp .env.example .env
# Edit .env with your configuration

# Deploy with Docker Compose
docker-compose -f .coolify/docker-compose.yml up -d
```

## 📋 Prerequisites

- Docker & Docker Compose
- OpenAI API Key ([Get one here](https://platform.openai.com/api-keys))
- Domain name (optional, can use localhost)
- Coolify instance (for production deployment)

## 🛠️ Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `OPENAI_API_KEY` | ✅ | - | OpenAI API key for embeddings |
| `DOMAIN` | ❌ | localhost | Your domain name |
| `APP_NAME` | ❌ | openmemory | Application name prefix |
| `LOG_LEVEL` | ❌ | INFO | Logging level (DEBUG, INFO, WARNING, ERROR) |
| `MAX_MEMORY_SIZE` | ❌ | 1000 | Maximum number of memories |
| `EMBEDDING_MODEL` | ❌ | text-embedding-3-small | OpenAI embedding model |

## 🔌 MCP Client Setup

### Claude Desktop

Add to your Claude Desktop configuration:

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

Add to your Cursor configuration:

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

### Auto-Install (Recommended)

```bash
npx install-mcp i "https://your-domain.com/mcp/claude/sse/YOUR_USERNAME" --client claude
```

## 🚀 Coolify Deployment

### 1. Create New Project

1. Go to your Coolify dashboard
2. Create new project: "OpenMemory MCP"
3. Choose "Git Repository" as source
4. Set repository URL: `https://github.com/yourusername/openmemory-mcp-coolify.git`

### 2. Configuration

- **Docker Compose File**: `.coolify/docker-compose.yml`
- **Environment**: Set required variables
- **Domain**: Configure your domain with SSL

### 3. Deploy

Push to `main` branch or trigger manual deployment from Coolify dashboard.

## 📊 Services

| Service | Port | Description | Health Check |
|---------|------|-------------|--------------|
| **UI** | 3000 | React dashboard for memory management | `GET /` |
| **API** | 8765 | FastAPI backend with MCP endpoints | `GET /health` |
| **Qdrant** | 6333 | Vector database for semantic search | `GET /health` |
| **Redis** | 6379 | Optional caching layer | `PING` |

## 🔧 Management Commands

```bash
# Deploy/Update
./scripts/deploy.sh

# Check status
./scripts/status.sh

# View logs
./scripts/logs.sh [service-name]

# Backup data
./scripts/backup.sh

# Stop services
./scripts/stop.sh
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Mem0](https://github.com/mem0ai/mem0) - Original OpenMemory implementation
- [Model Context Protocol](https://modelcontextprotocol.io/) - MCP specification
- [Coolify](https://coolify.io/) - Self-hosted deployment platform

---

<div align="center">

**Made with ❤️ for the AI community**

[⭐ Star this repository](https://github.com/yourusername/openmemory-mcp-coolify) if you find it helpful!

</div>
