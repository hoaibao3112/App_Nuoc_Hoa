import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request>();
    
    // Đọc accessToken từ cookie thay vì header
    const token = request.cookies?.['accessToken'];
    
    if (!token) {
      throw new UnauthorizedException('Không tìm thấy token xác thực (chưa đăng nhập)');
    }
    
    try {
      // Xác thực token
      const payload = this.jwtService.verify(token, { secret: process.env.JWT_SECRET });
      // Gán payload (chứa userId, email, role) vào request.user để dùng ở các controller
      request['user'] = payload;
    } catch {
      throw new UnauthorizedException('Token không hợp lệ hoặc đã hết hạn');
    }
    
    return true;
  }
}
