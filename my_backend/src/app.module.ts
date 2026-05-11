import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { ProductsModule } from './products/products.module';
import { CategoriesModule } from './categories/categories.module';
import { CartModule } from './cart/cart.module';
import { OrdersModule } from './orders/orders.module';
import { UploadModule } from './upload/upload.module';
import { ReviewsModule } from './reviews/reviews.module';
import { WishlistsModule } from './wishlists/wishlists.module';
import { VouchersModule } from './vouchers/vouchers.module';

@Module({
  imports: [
    // Tải cấu hình biến môi trường
    ConfigModule.forRoot({
      isGlobal: true, // Áp dụng ConfigModule trên toàn cục
    }),
    // Cấu hình TypeORM kết nối PostgreSQL (Supabase)
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        url: configService.get<string>('DATABASE_URL'),
        autoLoadEntities: true, // Tự động tìm và nạp các entity
        synchronize: true, // Cảnh báo: Chỉ dùng cho dev, prod nên dùng migration
        ssl: {
          rejectUnauthorized: false, // Thường cần thiết khi kết nối Supabase
        },
      }),
      inject: [ConfigService],
    }),
    // Đăng ký các modules
    AuthModule,
    UsersModule,
    ProductsModule,
    CategoriesModule,
    CartModule,
    OrdersModule,
    UploadModule,
    ReviewsModule,
    WishlistsModule,
    VouchersModule,
  ],
})
export class AppModule {}
