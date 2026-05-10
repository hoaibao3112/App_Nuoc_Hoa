import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import * as cookieParser from 'cookie-parser';
import { TransformInterceptor } from './common/interceptors/transform.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Đặt prefix cho tất cả các route (VD: /api/auth, /api/products)
  app.setGlobalPrefix('api');

  // Bật CORS cho phép Flutter gọi API kèm theo Cookie
  app.enableCors({
    origin: true, // Trong thực tế nên để domain cụ thể hoặc list domain của frontend/app
    credentials: true, // Cho phép đính kèm cookie
  });

  // Sử dụng cookie-parser để đọc cookie từ request
  app.use(cookieParser());

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
