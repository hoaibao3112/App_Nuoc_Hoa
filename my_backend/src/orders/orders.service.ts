import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';
import { CartService } from '../cart/cart.service';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private orderRepository: Repository<Order>,
    @InjectRepository(OrderItem)
    private orderItemRepository: Repository<OrderItem>,
    private cartService: CartService,
  ) {}

  async createFromCart(userId: string): Promise<Order> {
    const cartItems = await this.cartService.findCartByUser(userId);
    if (cartItems.length === 0) {
      throw new BadRequestException('Giỏ hàng trống');
    }

    let totalAmount = 0;
    const orderItems: OrderItem[] = [];

    // Tính tổng tiền và tạo các item của order
    for (const item of cartItems) {
      const price = Number(item.product.price);
      totalAmount += price * item.quantity;
      
      const orderItem = this.orderItemRepository.create({
        product: item.product,
        price: price,
        quantity: item.quantity,
      });
      orderItems.push(orderItem);
    }

    // Tạo đơn hàng
    const order = this.orderRepository.create({
      user: { id: userId },
      totalAmount,
      status: 'PENDING',
      items: orderItems,
    });

    const savedOrder = await this.orderRepository.save(order);

    // Xóa giỏ hàng sau khi tạo đơn
    for (const item of cartItems) {
      await this.cartService.remove(userId, item.id);
    }

    return savedOrder;
  }

  async findOrdersByUser(userId: string): Promise<Order[]> {
    return this.orderRepository.find({
      where: { user: { id: userId } },
      relations: ['items', 'items.product'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(userId: string, orderId: string): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id: orderId, user: { id: userId } },
      relations: ['items', 'items.product'],
    });

    if (!order) {
      throw new NotFoundException('Đơn hàng không tồn tại');
    }

    return order;
  }

  async cancelOrder(userId: string, orderId: string): Promise<Order> {
    const order = await this.findOne(userId, orderId);

    if (order.status !== 'PENDING') {
      throw new BadRequestException('Chỉ có thể huỷ đơn hàng đang chờ xử lý');
    }

    order.status = 'CANCELLED';
    return this.orderRepository.save(order);
  }
}
