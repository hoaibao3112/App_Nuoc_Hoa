import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Address } from './entities/address.entity';
import { CreateAddressDto } from './dto/create-address.dto';

@Injectable()
export class AddressesService {
  constructor(
    @InjectRepository(Address)
    private addressRepository: Repository<Address>,
  ) {}

  async create(userId: string, createAddressDto: CreateAddressDto): Promise<Address> {
    if (createAddressDto.isDefault) {
      await this.addressRepository.update({ userId }, { isDefault: false });
    }
    
    // Check if this is the first address, make it default automatically
    const count = await this.addressRepository.count({ where: { userId } });
    if (count === 0) {
      createAddressDto.isDefault = true;
    }

    const address = this.addressRepository.create({
      ...createAddressDto,
      userId,
    });
    return this.addressRepository.save(address);
  }

  async findAllByUser(userId: string): Promise<Address[]> {
    return this.addressRepository.find({
      where: { userId },
      order: { isDefault: 'DESC', createdAt: 'DESC' },
    });
  }

  async findOne(id: string, userId: string): Promise<Address> {
    const address = await this.addressRepository.findOne({ where: { id, userId } });
    if (!address) {
      throw new NotFoundException(`Address with ID ${id} not found`);
    }
    return address;
  }

  async update(id: string, userId: string, updateAddressDto: Partial<CreateAddressDto>): Promise<Address> {
    const address = await this.findOne(id, userId);

    if (updateAddressDto.isDefault && !address.isDefault) {
      await this.addressRepository.update({ userId }, { isDefault: false });
    }

    Object.assign(address, updateAddressDto);
    return this.addressRepository.save(address);
  }

  async remove(id: string, userId: string): Promise<void> {
    const address = await this.findOne(id, userId);
    await this.addressRepository.remove(address);
    
    // If we deleted the default address, make the most recent one default
    if (address.isDefault) {
      const nextAddress = await this.addressRepository.findOne({
        where: { userId },
        order: { createdAt: 'DESC' },
      });
      if (nextAddress) {
        nextAddress.isDefault = true;
        await this.addressRepository.save(nextAddress);
      }
    }
  }
}
