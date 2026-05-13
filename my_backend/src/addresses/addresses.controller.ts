import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { AddressesService } from './addresses.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/user.decorator';

@Controller('addresses')
@UseGuards(JwtAuthGuard)
export class AddressesController {
  constructor(private readonly addressesService: AddressesService) {}

  @Post()
  create(@CurrentUser() user: any, @Body() createAddressDto: CreateAddressDto) {
    return this.addressesService.create(user.sub, createAddressDto);
  }

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.addressesService.findAllByUser(user.sub);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser() user: any) {
    return this.addressesService.findOne(id, user.sub);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @CurrentUser() user: any,
    @Body() updateAddressDto: Partial<CreateAddressDto>,
  ) {
    return this.addressesService.update(id, user.sub, updateAddressDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @CurrentUser() user: any) {
    return this.addressesService.remove(id, user.sub);
  }
}
