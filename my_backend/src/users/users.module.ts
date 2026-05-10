import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User])], // Đăng ký User entity
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService], // Export để module khác dùng được (VD: AuthModule)
})
export class UsersModule {}
