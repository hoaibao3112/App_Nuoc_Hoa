# Stage 1: Build
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Cài đặt các công cụ cần thiết để build native modules (như bcrypt)
RUN apk add --no-cache python3 make g++

# Cài đặt dependencies bằng npm (ổn định hơn trong Docker với native modules)
RUN npm install

# Copy source code
COPY . .

# Build dự án
RUN npm run build

# Stage 2: Run
FROM node:22-alpine AS runner

WORKDIR /app

# Copy các file cần thiết từ stage builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose port (theo PORT trong .env, mặc định 3000)
EXPOSE 3000

# Chạy ứng dụng
CMD ["node", "dist/main"]
