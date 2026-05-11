import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface GoogleUserInfo {
  googleId: string;
  email: string;
  fullName: string;
  avatarUrl: string;
}

@Injectable()
export class GoogleAuthService {
  private readonly GOOGLE_CLIENT_ID: string;

  constructor(private configService: ConfigService) {
    this.GOOGLE_CLIENT_ID = this.configService.get<string>('GOOGLE_CLIENT_ID') || '';
  }

  /**
   * Xác thực Google ID Token bằng Google tokeninfo API.
   * Flutter gửi idToken lên Backend → Backend xác thực với Google.
   * Không cần thư viện bên ngoài, chỉ dùng fetch có sẵn trong Node.js 18+.
   */
  async verifyIdToken(idToken: string): Promise<GoogleUserInfo> {
    try {
      const response = await fetch(
        `https://oauth2.googleapis.com/tokeninfo?id_token=${idToken}`,
      );

      if (!response.ok) {
        throw new UnauthorizedException('Google ID Token không hợp lệ');
      }

      const payload = await response.json() as any;

      // Kiểm tra token được cấp cho đúng app
      if (
        this.GOOGLE_CLIENT_ID &&
        payload.aud !== this.GOOGLE_CLIENT_ID
      ) {
        throw new UnauthorizedException('Google ID Token không khớp với Client ID');
      }

      // Kiểm tra token còn hạn
      const expiry = parseInt(payload.exp, 10) * 1000;
      if (Date.now() > expiry) {
        throw new UnauthorizedException('Google ID Token đã hết hạn');
      }

      return {
        googleId: payload.sub,
        email: payload.email,
        fullName: payload.name || payload.given_name || '',
        avatarUrl: payload.picture || '',
      };
    } catch (error) {
      if (error instanceof UnauthorizedException) throw error;
      throw new UnauthorizedException('Không thể xác thực Google ID Token: ' + error.message);
    }
  }
}
