import { Injectable, NotFoundException, ForbiddenException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Review } from './entities/review.entity';
import { CreateReviewDto, UpdateReviewDto } from './dto/review.dto';

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review)
    private reviewRepository: Repository<Review>,
  ) {}

  // Tạo đánh giá mới cho sản phẩm
  async create(userId: string, dto: CreateReviewDto): Promise<Review> {
    // Kiểm tra xem user đã review sản phẩm này chưa
    const existing = await this.reviewRepository.findOne({
      where: { user: { id: userId }, product: { id: dto.productId } },
    });
    if (existing) {
      throw new ConflictException('Bạn đã đánh giá sản phẩm này rồi');
    }

    const review = this.reviewRepository.create({
      user: { id: userId } as any,
      product: { id: dto.productId } as any,
      rating: dto.rating,
      comment: dto.comment,
      imageUrl: dto.imageUrl,
    });
    return this.reviewRepository.save(review);
  }

  // Lấy tất cả đánh giá của 1 sản phẩm
  async findByProduct(productId: string): Promise<{ items: Review[]; avgRating: number; total: number }> {
    const [items, total] = await this.reviewRepository.findAndCount({
      where: { product: { id: productId } },
      relations: ['user'],
      order: { createdAt: 'DESC' },
    });

    const avgRating = total > 0
      ? Math.round((items.reduce((sum, r) => sum + r.rating, 0) / total) * 10) / 10
      : 0;

    return { items, avgRating, total };
  }

  // Lấy tất cả đánh giá của user đang đăng nhập
  async findByUser(userId: string): Promise<Review[]> {
    return this.reviewRepository.find({
      where: { user: { id: userId } },
      relations: ['product'],
      order: { createdAt: 'DESC' },
    });
  }

  // Cập nhật đánh giá (chỉ chủ sở hữu mới được sửa)
  async update(userId: string, reviewId: string, dto: UpdateReviewDto): Promise<Review> {
    const review = await this.reviewRepository.findOne({
      where: { id: reviewId },
      relations: ['user'],
    });

    if (!review) throw new NotFoundException('Đánh giá không tồn tại');
    if (review.user.id !== userId) throw new ForbiddenException('Bạn không có quyền sửa đánh giá này');

    Object.assign(review, dto);
    return this.reviewRepository.save(review);
  }

  // Xóa đánh giá (chỉ chủ sở hữu mới được xóa)
  async remove(userId: string, reviewId: string): Promise<{ message: string }> {
    const review = await this.reviewRepository.findOne({
      where: { id: reviewId },
      relations: ['user'],
    });

    if (!review) throw new NotFoundException('Đánh giá không tồn tại');
    if (review.user.id !== userId) throw new ForbiddenException('Bạn không có quyền xóa đánh giá này');

    await this.reviewRepository.remove(review);
    return { message: 'Xóa đánh giá thành công' };
  }
}
