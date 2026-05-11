import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { CartService } from './cart.service';
import { AddToCartDto, UpdateCartItemDto } from './dto/cart.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/user.decorator';

@Controller('cart')
@UseGuards(JwtAuthGuard)
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Get()
  getCart(@CurrentUser() user: any) {
    return this.cartService.findCartByUser(user.sub);
  }

  @Post('add')
  addToCart(@CurrentUser() user: any, @Body() dto: AddToCartDto) {
    return this.cartService.addToCart(user.sub, dto);
  }

  @Put('update/:itemId')
  updateQuantity(
    @CurrentUser() user: any,
    @Param('itemId') itemId: string,
    @Body() dto: UpdateCartItemDto,
  ) {
    return this.cartService.updateQuantity(user.sub, itemId, dto);
  }

  @Delete('remove/:itemId')
  remove(@CurrentUser() user: any, @Param('itemId') itemId: string) {
    return this.cartService.remove(user.sub, itemId);
  }

  @Delete('clear')
  clear(@CurrentUser() user: any) {
    return this.cartService.clearCart(user.sub);
  }
}

