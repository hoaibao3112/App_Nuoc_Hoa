import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order-item.entity';
import { CartService } from '../cart/cart.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { OrderStatus } from './dto/create-order.dto';
import { VouchersService } from '../vouchers/vouchers.service';
import { AddressesService } from '../addresses/addresses.service';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private orderRepository: Repository<Order>,
    @InjectRepository(OrderItem)
    private orderItemRepository: Repository<OrderItem>,
    private cartService: CartService,
    private vouchersService: VouchersService,
    private addressesService: AddressesService,
    private dataSource: DataSource,
  ) {}

  async createFromCart(
    userId: string,
    createOrderDto: CreateOrderDto,
  ): Promise<Order> {
    const {
      addressId,
      voucherCode,
      paymentMethod,
      shippingFee = 0,
    } = createOrderDto;

    // 1. Kiểm tra địa chỉ
    const address = await this.addressesService.findOne(addressId, userId);

    // 2. Lấy giỏ hàng
    const cartItems = await this.cartService.findCartByUser(userId);
    if (cartItems.length === 0) {
      throw new BadRequestException('Giỏ hàng trống');
    }

    // 3. Sử dụng Transaction để đảm bảo tính toàn vẹn
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      let subTotal = 0;
      const items: OrderItem[] = [];

      for (const item of cartItems) {
        const price = Number(item.product.price);
        subTotal += price * item.quantity;

        items.push(
          this.orderItemRepository.create({
            product: item.product,
            price: price,
            quantity: item.quantity,
          }),
        );
      }

      // 4. Xử lý Voucher
      let discountAmount = 0;
      let voucherId: string | undefined = undefined;
      if (voucherCode) {
        const voucherRes = await this.vouchersService.validateVoucher({
          code: voucherCode,
          orderAmount: subTotal,
        });
        discountAmount = voucherRes.discountAmount;
        voucherId = voucherRes.voucher.id;

        // Cập nhật lượt dùng voucher
        await queryRunner.manager.update('Voucher', voucherId, {
          usedCount: voucherRes.voucher.usedCount + 1,
        });
      }

      const totalAmount = subTotal + Number(shippingFee) - discountAmount;

      // 5. Tạo Order
      const orderData: any = {
        user: { id: userId },
        totalAmount: totalAmount < 0 ? 0 : totalAmount,
        receiverName: address.receiverName,
        receiverPhone: address.phone,
        shippingAddress: address.address,
        addressId: addressId,
        paymentMethod,
        shippingFee,
        discountAmount,
        voucherId,
        status: 'PENDING',
        items,
      };

      const order = this.orderRepository.create(orderData);
      const savedOrder = await queryRunner.manager.save(order);

      // 6. Xóa giỏ hàng sau khi tạo đơn
      await this.cartService.clearCart(userId);

      await queryRunner.commitTransaction();
      return savedOrder as any;
    } catch (err) {
      await queryRunner.rollbackTransaction();
      throw err;
    } finally {
      await queryRunner.release();
    }
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

  async updateStatus(orderId: string, status: OrderStatus): Promise<Order> {
    const order = await this.orderRepository.findOne({
      where: { id: orderId },
      relations: ['items', 'items.product'],
    });

    if (!order) {
      throw new NotFoundException('Đơn hàng không tồn tại');
    }

    order.status = status;
    if (status === OrderStatus.DELIVERED) {
      order.paymentStatus = 'PAID';
    }

    return this.orderRepository.save(order);
  }
}
