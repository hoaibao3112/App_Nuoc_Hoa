import {
  IsNotEmpty,
  IsOptional,
  IsString,
  IsEnum,
  IsNumber,
  IsUUID,
} from 'class-validator';

export enum PaymentMethod {
  COD = 'COD',
  VNPAY = 'VNPAY',
  MOMO = 'MOMO',
}

export enum OrderStatus {
  PENDING = 'PENDING',
  PROCESSING = 'PROCESSING',
  SHIPPED = 'SHIPPED',
  DELIVERED = 'DELIVERED',
  CANCELLED = 'CANCELLED',
}

export class CreateOrderDto {
  @IsUUID()
  @IsNotEmpty({ message: 'AddressId là bắt buộc' })
  addressId: string;

  @IsString()
  @IsOptional()
  voucherCode?: string;

  @IsEnum(PaymentMethod, { message: 'Phương thức thanh toán không hợp lệ' })
  @IsNotEmpty({ message: 'Phương thức thanh toán là bắt buộc' })
  paymentMethod: PaymentMethod;

  @IsNumber()
  @IsOptional()
  shippingFee?: number;
}

export class UpdateOrderStatusDto {
  @IsEnum(OrderStatus, { message: 'Trạng thái đơn hàng không hợp lệ' })
  @IsNotEmpty({ message: 'Trạng thái đơn hàng là bắt buộc' })
  status: OrderStatus;
}
