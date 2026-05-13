import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { VouchersService } from './vouchers.service';
import { ValidateVoucherDto } from './dto/voucher.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';

@Controller('vouchers')
export class VouchersController {
  constructor(private readonly vouchersService: VouchersService) {}

  @Get()
  findAll() {
    return this.vouchersService.findAllActive();
  }

  @Post('validate')
  validate(@Body() dto: ValidateVoucherDto) {
    return this.vouchersService.validateVoucher(dto);
  }

  @Get('summary/count')
  @UseGuards(JwtAuthGuard)
  async getCount() {
    const vouchers = await this.vouchersService.findAllActive();
    return { count: vouchers.length };
  }
}
