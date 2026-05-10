import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class UploadService {
  constructor(private configService: ConfigService) {}

  async uploadFile(file: Express.Multer.File): Promise<string> {
    // Boilerplate logic để upload ảnh lên Supabase Storage
    // 1. Lấy SUPABASE_URL và SUPABASE_KEY từ ConfigService
    // 2. Dùng Supabase Client để upload file
    // 3. Trả về public URL
    return 'https://supabase.co/storage/v1/object/public/images/dummy.jpg';
  }
}
