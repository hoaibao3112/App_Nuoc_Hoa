import { registerAs } from '@nestjs/config';

// Cấu hình Database
export default registerAs('database', () => ({
  url: process.env.DATABASE_URL,
}));
