import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CartItem } from './entities/cart-item.entity';
import { AddToCartDto, UpdateCartItemDto } from './dto/cart.dto';
import { User } from '../users/entities/user.entity';
import { Product } from '../products/entities/product.entity';

@Injectable()
export class CartService {
  constructor(
    @InjectRepository(CartItem)
    private cartItemRepository: Repository<CartItem>,
  ) {}

  async findCartByUser(userId: string): Promise<CartItem[]> {
    return this.cartItemRepository.find({
      where: { user: { id: userId } },
      relations: ['product', 'product.category'],
    });
  }

  async addToCart(userId: string, dto: AddToCartDto): Promise<CartItem> {
    let cartItem = await this.cartItemRepository.findOne({
      where: { user: { id: userId }, product: { id: dto.productId } },
    });

    if (cartItem) {
      cartItem.quantity += dto.quantity;
    } else {
      cartItem = this.cartItemRepository.create({
        user: { id: userId } as User,
        product: { id: dto.productId } as Product,
        quantity: dto.quantity,
      });
    }

    return this.cartItemRepository.save(cartItem);
  }

  async updateQuantity(userId: string, itemId: string, dto: UpdateCartItemDto): Promise<CartItem> {
    const cartItem = await this.cartItemRepository.findOne({
      where: { id: itemId, user: { id: userId } },
    });

    if (!cartItem) throw new NotFoundException('Không tìm thấy sản phẩm trong giỏ hàng');

    cartItem.quantity = dto.quantity;
    return this.cartItemRepository.save(cartItem);
  }

  async remove(userId: string, itemId: string): Promise<void> {
    const cartItem = await this.cartItemRepository.findOne({
      where: { id: itemId, user: { id: userId } },
    });

    if (!cartItem) throw new NotFoundException('Không tìm thấy sản phẩm trong giỏ hàng');

    await this.cartItemRepository.remove(cartItem);
  }

  async clearCart(userId: string): Promise<void> {
    await this.cartItemRepository.delete({ user: { id: userId } });
  }
}

