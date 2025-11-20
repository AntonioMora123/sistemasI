FROM node:18-alpine

WORKDIR /app

# Copiar package.json
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar código
COPY . .

# Verificar que server.js existe
RUN ls -la

# Exponer puerto
EXPOSE 5000

# Comando de inicio
CMD ["node", "server.js"]