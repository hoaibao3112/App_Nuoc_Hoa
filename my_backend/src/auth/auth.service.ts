import { Injectable, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { RegisterDto, LoginDto } from './dto/auth.dto';
import { UsersService } from '../users/users.service';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { ConfigService } from '@nestjs/config';
import { GoogleAuthService } from './google-auth.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private googleAuthService: GoogleAuthService,
  ) {}

  async register(registerDto: RegisterDto) {
    const existingUser = await this.usersService.findByEmail(registerDto.email);
    if (existingUser) {
      throw new BadRequestException('Email đã tồn tại');
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(registerDto.password, salt);

    const user = await this.usersService.create({
      email: registerDto.email,
      passwordHash,
      fullName: registerDto.fullName,
      phone: registerDto.phone,
    });

    // Xóa passwordHash trước khi trả về
    const { passwordHash: _, refreshToken: __, ...result } = user;
    return result;
  }

  async login(loginDto: LoginDto) {
    const user = await this.usersService.findByEmail(loginDto.email);
    if (!user) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }

    const isMatch = await bcrypt.compare(loginDto.password, user.passwordHash);
    if (!isMatch) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }

    return this.generateTokens(user);
  }

  async refresh(refreshToken: string) {
    if (!refreshToken) {
      throw new UnauthorizedException('Refresh token không tồn tại');
    }

    try {
      // Xác thực refreshToken
      const payload = this.jwtService.verify(refreshToken, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      });

      const user = await this.usersService.findOne(payload.sub);
      if (!user || user.refreshToken !== refreshToken) {
        throw new UnauthorizedException('Refresh token không hợp lệ hoặc đã bị thu hồi');
      }

      return this.generateTokens(user);
    } catch (e) {
      throw new UnauthorizedException('Refresh token hết hạn hoặc không hợp lệ');
    }
  }

  async loginWithGoogle(idToken: string) {
    // 1. Xác thực Google ID Token
    const googleUser = await this.googleAuthService.verifyIdToken(idToken);

    // 2. Tìm user theo googleId hoặc email
    let user = await this.usersService.findByGoogleId(googleUser.googleId);

    if (!user) {
      // Thử tìm theo email (user đã đăng ký bằng email thông thường)
      user = await this.usersService.findByEmail(googleUser.email);

      if (user) {
        // Liên kết tài khoản Google với tài khoản email hiện có
        user = await this.usersService.updateProfile(user.id, {
          googleId: googleUser.googleId,
          avatarUrl: user.avatarUrl || googleUser.avatarUrl,
        });
      } else {
        // Tạo tài khoản mới từ Google
        user = await this.usersService.create({
          email: googleUser.email,
          fullName: googleUser.fullName,
          avatarUrl: googleUser.avatarUrl,
          googleId: googleUser.googleId,
          passwordHash: '', // Không có mật khẩu
        });
      }
    }

    return this.generateTokens(user);
  }

  private async generateTokens(user: any) {
    const payload = { sub: user.id, email: user.email, role: user.role };

    const accessToken = this.jwtService.sign(payload); // Dùng secret mặc định cấu hình ở module (15m)
    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      expiresIn: (this.configService.get<string>('JWT_REFRESH_EXPIRES_IN') || '7d') as any,
    });

    // Lưu refreshToken vào DB
    await this.usersService.updateRefreshToken(user.id, refreshToken);

    const { passwordHash: _, refreshToken: __, ...userData } = user;

    return {
      user: userData,
      accessToken,
      refreshToken,
    };
  }
}
