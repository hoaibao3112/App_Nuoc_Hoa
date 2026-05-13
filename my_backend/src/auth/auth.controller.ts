import { Controller, Post, Body, Get, Req, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto, ChangePasswordDto } from './dto/auth.dto';
import { Request } from 'express';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/user.decorator';
import { UsersService } from '../users/users.service';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  @Post('register')
  async register(@Body() registerDto: RegisterDto) {
    const user = await this.authService.register(registerDto);
    return { user };
  }

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    const { user, accessToken, refreshToken } = await this.authService.login(loginDto);
    
    // Trả token trực tiếp qua Body JSON thay vì Cookie
    return { user, accessToken, refreshToken };
  }

  @Post('logout')
  async logout(@CurrentUser() user: any, @Req() req: any) {
    if (user && user.sub) {
      await this.usersService.updateRefreshToken(user.sub, null);
    }
    return { message: 'Đăng xuất thành công' };
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  async getProfile(@CurrentUser() user: any) {
    const userProfile = await this.usersService.findOne(user.sub);
    if (!userProfile) return null;
    const { passwordHash: _, refreshToken: __, ...result } = userProfile;
    return result;
  }

  @Post('google')
  async loginWithGoogle(@Body('idToken') idToken: string) {
    if (!idToken) {
      return { message: 'idToken là bắt buộc' };
    }
    const { user, accessToken, refreshToken } = await this.authService.loginWithGoogle(idToken);
    return { user, accessToken, refreshToken };
  }

  @Post('refresh')
  async refresh(@Body('refreshToken') oldRefreshToken: string) {
    const { user, accessToken, refreshToken } = await this.authService.refresh(oldRefreshToken);
    return { accessToken, refreshToken };
  }

  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  async changePassword(@CurrentUser() user: any, @Body() dto: ChangePasswordDto) {
    return this.authService.changePassword(user.sub, dto);
  }
}

