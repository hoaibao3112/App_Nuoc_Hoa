import { Controller, Get, Param, Patch, Body, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/user.decorator';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  // Lấy profile user hiện tại (thay cho getProfile bên auth nếu cần đồng nhất)
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getMe(@CurrentUser() user: any) {
    const profile = await this.usersService.findOne(user.sub);
    return this.usersService.toSafeUser(profile);
  }

  // Cập nhật profile user hiện tại
  @Patch('me')
  @UseGuards(JwtAuthGuard)
  async updateMe(@CurrentUser() user: any, @Body() dto: UpdateUserDto) {
    const updated = await this.usersService.updateProfile(user.sub, dto);
    return this.usersService.toSafeUser(updated);
  }

  // Lấy profile user qua ID (cho Admin hoặc public profile)
  @Get(':id')
  @UseGuards(JwtAuthGuard)
  async findOne(@Param('id') id: string) {
    const profile = await this.usersService.findOne(id);
    return this.usersService.toSafeUser(profile);
  }
}

