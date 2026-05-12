import { Controller, Get, Post, Delete, Param, UseGuards } from '@nestjs/common';
import { WishlistsService } from './wishlists.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/user.decorator';

@Controller('wishlists')
@UseGuards(JwtAuthGuard)
export class WishlistsController {
  constructor(private readonly wishlistsService: WishlistsService) {}

  // GET /wishlists — Lấy danh sách yêu thích của tôi
  @Get()
  findAll(@CurrentUser() user: any) {
    return this.wishlistsService.findByUser(user.sub);
  }

  // POST /wishlists/:productId — Thêm sản phẩm vào yêu thích
  @Post(':productId')
  add(@CurrentUser() user: any, @Param('productId') productId: string) {
    return this.wishlistsService.add(user.sub, productId);
  }

  // POST /wishlists/:productId/toggle — Toggle yêu thích (thêm/xóa)
  @Post(':productId/toggle')
  toggle(@CurrentUser() user: any, @Param('productId') productId: string) {
    return this.wishlistsService.toggle(user.sub, productId);
  }

  // GET /wishlists/:productId/check — Kiểm tra sản phẩm có trong yêu thích không
  @Get(':productId/check')
  check(@CurrentUser() user: any, @Param('productId') productId: string) {
    return this.wishlistsService.isWishlisted(user.sub, productId);
  }

  // DELETE /wishlists/:id — Xóa mục yêu thích theo ID
  @Delete(':id')
  remove(@CurrentUser() user: any, @Param('id') id: string) {
    return this.wishlistsService.remove(user.sub, id);
  }
}
