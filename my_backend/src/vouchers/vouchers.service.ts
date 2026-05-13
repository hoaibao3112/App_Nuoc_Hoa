import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan } from 'typeorm';
import { Voucher } from './entities/voucher.entity';
import { ValidateVoucherDto } from './dto/voucher.dto';

@Injectable()
export class VouchersService {
  constructor(
    @InjectRepository(Voucher)
    private readonly voucherRepository: Repository<Voucher>,
  ) {}

  async findAllActive(): Promise<Voucher[]> {
    return this.voucherRepository.find({
      where: {
        isActive: true,
      },
      order: { createdAt: 'DESC' },
    });
  }

  async validateVoucher(dto: ValidateVoucherDto) {
    const voucher = await this.voucherRepository.findOne({
      where: { code: dto.code, isActive: true },
    });

    if (!voucher) {
      throw new BadRequestException('Mã giảm giá không tồn tại hoặc đã hết hạn');
    }

    if (voucher.expiryDate && new Date() > voucher.expiryDate) {
      throw new BadRequestException('Mã giảm giá đã hết hạn');
    }

    if (voucher.usedCount >= voucher.usageLimit) {
      throw new BadRequestException('Mã giảm giá đã hết lượt sử dụng');
    }

    if (dto.orderAmount < voucher.minOrderValue) {
      throw new BadRequestException(
        `Đơn hàng tối thiểu ${voucher.minOrderValue}đ để áp dụng mã này`,
      );
    }

    let discountAmount = 0;
    if (voucher.discountType === 'PERCENT') {
      discountAmount = (dto.orderAmount * Number(voucher.discountValue)) / 100;
      if (voucher.maxDiscount && discountAmount > voucher.maxDiscount) {
        discountAmount = Number(voucher.maxDiscount);
      }
    } else {
      discountAmount = Number(voucher.discountValue);
    }

    return {
      isValid: true,
      discountAmount,
      voucher,
    };
  }
}
