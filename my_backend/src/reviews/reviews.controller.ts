import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ReviewsService } from './reviews.service';
import { CreateReviewDto, UpdateReviewDto } from './dto/review.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/user.decorator';

@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  // GET /reviews/product/:productId — Lấy tất cả review của sản phẩm (công khai)
  @Get('product/:productId')
  findByProduct(@Param('productId') productId: string) {
    return this.reviewsService.findByProduct(productId);
  }

  // GET /reviews/me — Lấy review của tôi
  @Get('me')
  @UseGuards(JwtAuthGuard)
  findMyReviews(@CurrentUser() user: any) {
    return this.reviewsService.findByUser(user.sub);
  }

  // POST /reviews — Tạo review mới
  @Post()
  @UseGuards(JwtAuthGuard)
  create(@CurrentUser() user: any, @Body() dto: CreateReviewDto) {
    return this.reviewsService.create(user.sub, dto);
  }

  // PUT /reviews/:id — Sửa review
  @Put(':id')
  @UseGuards(JwtAuthGuard)
  update(@CurrentUser() user: any, @Param('id') id: string, @Body() dto: UpdateReviewDto) {
    return this.reviewsService.update(user.sub, id, dto);
  }

  // DELETE /reviews/:id — Xóa review
  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@CurrentUser() user: any, @Param('id') id: string) {
    return this.reviewsService.remove(user.sub, id);
  }
}
