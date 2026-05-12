import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Wishlist } from './entities/wishlist.entity';

@Injectable()
export class WishlistsService {
  constructor(
    @InjectRepository(Wishlist)
    private wishlistRepository: Repository<Wishlist>,
  ) {}

  // Lấy danh sách yêu thích của user
  async findByUser(userId: string): Promise<Wishlist[]> {
    return this.wishlistRepository.find({
      where: { user: { id: userId } },
      relations: ['product', 'product.category'],
      order: { createdAt: 'DESC' },
    });
  }

  // Thêm sản phẩm vào yêu thích
  async add(userId: string, productId: string): Promise<Wishlist> {
    const existing = await this.wishlistRepository.findOne({
      where: { user: { id: userId }, product: { id: productId } },
    });
    if (existing) {
      throw new ConflictException('Sản phẩm đã có trong danh sách yêu thích');
    }

    const wishlist = this.wishlistRepository.create({
      user: { id: userId } as any,
      product: { id: productId } as any,
    });
    return this.wishlistRepository.save(wishlist);
  }

  // Xóa sản phẩm khỏi yêu thích theo wishlist ID
  async remove(userId: string, wishlistId: string): Promise<{ message: string }> {
    const item = await this.wishlistRepository.findOne({
      where: { id: wishlistId, user: { id: userId } },
    });
    if (!item) throw new NotFoundException('Mục yêu thích không tồn tại');

    await this.wishlistRepository.remove(item);
    return { message: 'Đã xóa khỏi danh sách yêu thích' };
  }

  // Toggle: nếu chưa có thì thêm, nếu có rồi thì xóa
  async toggle(userId: string, productId: string): Promise<{ added: boolean; message: string }> {
    const existing = await this.wishlistRepository.findOne({
      where: { user: { id: userId }, product: { id: productId } },
    });

    if (existing) {
      await this.wishlistRepository.remove(existing);
      return { added: false, message: 'Đã xóa khỏi danh sách yêu thích' };
    }

    const wishlist = this.wishlistRepository.create({
      user: { id: userId } as any,
      product: { id: productId } as any,
    });
    await this.wishlistRepository.save(wishlist);
    return { added: true, message: 'Đã thêm vào danh sách yêu thích' };
  }

  // Kiểm tra 1 sản phẩm có trong danh sách yêu thích không
  async isWishlisted(userId: string, productId: string): Promise<{ wishlisted: boolean }> {
    const existing = await this.wishlistRepository.findOne({
      where: { user: { id: userId }, product: { id: productId } },
    });
    return { wishlisted: !!existing };
  }
}
