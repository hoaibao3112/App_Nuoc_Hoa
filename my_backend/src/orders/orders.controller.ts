import { Controller, Get, Post, Put, Param, UseGuards, Body } from '@nestjs/common';
import { OrdersService } from './orders.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/user.decorator';
import { CreateOrderDto } from './dto/create-order.dto';

@Controller('orders')
@UseGuards(JwtAuthGuard)
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post()
  create(@CurrentUser() user: any, @Body() createOrderDto: CreateOrderDto) {
    return this.ordersService.createFromCart(user.sub, createOrderDto);
  }

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.ordersService.findOrdersByUser(user.sub);
  }

  @Get('summary/count')
  async getCount(@CurrentUser() user: any) {
    const orders = await this.ordersService.findOrdersByUser(user.sub);
    const activeOrders = orders.filter(o => o.status !== 'CANCELLED' && o.status !== 'DELIVERED');
    return { count: activeOrders.length };
  }

  @Get(':id')
  findOne(@CurrentUser() user: any, @Param('id') id: string) {
    return this.ordersService.findOne(user.sub, id);
  }

  @Put(':id/cancel')
  cancel(@CurrentUser() user: any, @Param('id') id: string) {
    return this.ordersService.cancelOrder(user.sub, id);
  }
}
