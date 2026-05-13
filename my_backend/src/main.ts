import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Đặt prefix cho tất cả các route (VD: /api/auth, /api/products)
  app.setGlobalPrefix('api');

  // Bật CORS
  const corsOrigin = process.env.CORS_ORIGIN;
  app.enableCors({
    origin: corsOrigin ? corsOrigin.split(',').map((o) => o.trim()).filter(Boolean) : true,
    credentials: true,
  });

  // Kích hoạt class-validator toàn cục
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true, // Tự động transform các kiểu dữ liệu
    }),
  );

  // Áp dụng interceptor định dạng chuẩn response { success, message, data }
  app.useGlobalInterceptors(new TransformInterceptor());

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();

