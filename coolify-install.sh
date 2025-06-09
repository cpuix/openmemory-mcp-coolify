#!/bin/bash

# OpenMemory MCP Coolify Kurulum Scripti
# Bu script OpenMemory MCP'yi Coolify üzerinde tek komutla kurar

set -e

echo "🚀 OpenMemory MCP Coolify Kurulum Scripti"
echo "========================================="

# Renklendirme
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Hata yakalama fonksiyonu
error_exit() {
    echo -e "${RED}❌ HATA: $1${NC}" >&2
    exit 1
}

# Başarı mesajı
success_msg() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Bilgi mesajı
info_msg() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Uyarı mesajı
warning_msg() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Gerekli parametrelerin kontrolü
check_requirements() {
    info_msg "Gereklilikler kontrol ediliyor..."
    
    if [ -z "$OPENAI_API_KEY" ]; then
        echo -e "${YELLOW}OpenAI API Key gerekli!${NC}"
        read -p "OpenAI API Key: " -s OPENAI_API_KEY
        echo ""
        export OPENAI_API_KEY
    fi
    
    if [ -z "$DOMAIN" ]; then
        read -p "Domain adresiniz (örn: memory.yourdomain.com): " DOMAIN
        if [ -z "$DOMAIN" ]; then
            DOMAIN="localhost"
            warning_msg "Domain belirtilmedi, localhost kullanılacak"
        fi
        export DOMAIN
    fi
    
    success_msg "Gereklilikler OK"
}

# Environment dosyası oluştur
create_env_file() {
    info_msg "Environment dosyası oluşturuluyor..."
    
    cat > .env << EOF
# OpenMemory MCP Konfigürasyonu
OPENAI_API_KEY=${OPENAI_API_KEY}
DOMAIN=${DOMAIN}
ENVIRONMENT=production

# Qdrant Konfigürasyonu
QDRANT_URL=http://qdrant:6333
QDRANT_API_KEY=

# API Konfigürasyonu
HOST=0.0.0.0
PORT=8765

# UI Konfigürasyonu
REACT_APP_API_URL=https://${DOMAIN}/api
NODE_ENV=production

# Docker Compose proje adı
COMPOSE_PROJECT_NAME=openmemory-mcp
EOF

    success_msg "Environment dosyası oluşturuldu"
}

# Dizin yapısı oluşturma
create_directories() {
    info_msg "Dizin yapısı oluşturuluyor..."
    
    mkdir -p data/{qdrant,api} logs
    chmod -R 755 data logs
    
    success_msg "Dizin yapısı oluşturuldu"
}

# Deployment başlatma
start_deployment() {
    info_msg "Deployment başlatılıyor..."
    
    # Docker compose ile başlat
    docker-compose -f .coolify/docker-compose.yml up -d
    
    echo ""
    info_msg "Servisler başlatılıyor, lütfen bekleyin..."
    sleep 30
    
    # Health check
    echo ""
    info_msg "Health check yapılıyor..."
    
    api_health=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:8765/health" || echo "000")
    ui_health=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:3000/" || echo "000")
    
    if [ "$api_health" = "200" ]; then
        success_msg "API servisi çalışıyor"
    else
        warning_msg "API servisi henüz hazır değil (HTTP $api_health)"
    fi
    
    if [ "$ui_health" = "200" ]; then
        success_msg "UI servisi çalışıyor"
    else
        warning_msg "UI servisi henüz hazır değil (HTTP $ui_health)"
    fi
}

# Kurulum özeti
show_summary() {
    echo ""
    echo -e "${GREEN}🎉 OpenMemory MCP kurulum tamamlandı!${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    echo -e "${BLUE}📊 Dashboard:${NC} https://${DOMAIN}"
    echo -e "${BLUE}🔌 MCP Endpoint:${NC} https://${DOMAIN}/mcp"
    echo -e "${BLUE}📖 API Docs:${NC} https://${DOMAIN}/api/docs"
    echo ""
    echo -e "${YELLOW}⚠️  Bir kullanıcı adı oluşturmak için dashboard'u ziyaret edin!${NC}"
    echo -e "${YELLOW}⚠️  MCP client'larınızı yapılandırmayı unutmayın!${NC}"
}

# Ana kurulum fonksiyonu
main() {
    check_requirements
    create_env_file
    create_directories
    
    echo ""
    read -p "Deployment'ı şimdi başlatmak istiyor musunuz? (y/N): " start_now
    
    if [[ $start_now =~ ^[Yy]$ ]]; then
        start_deployment
    else
        info_msg "Deployment'ı daha sonra './scripts/deploy.sh' ile başlatabilirsiniz"
    fi
    
    show_summary
}

# Script'i çalıştır
main "$@"
