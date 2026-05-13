import { IsNotEmpty, IsOptional, IsString, IsEnum, IsNumber, IsUUID } from 'class-validator';

export enum PaymentMethod {
  COD = 'COD',
  VNPAY = 'VNPAY',
  MOMO = 'MOMO',
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
