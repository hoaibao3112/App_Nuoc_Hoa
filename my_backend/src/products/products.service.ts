import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like, Between, LessThanOrEqual, MoreThanOrEqual } from 'typeorm';
import { Product } from './entities/product.entity';
import { CreateProductDto, UpdateProductDto, FilterProductDto } from './dto/product.dto';
import { Category } from '../categories/entities/category.entity';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private productsRepository: Repository<Product>,
  ) {}

  async findAll(filter: FilterProductDto) {
    const page = parseInt(filter.page || '1', 10);
    const limit = parseInt(filter.limit || '10', 10);
    const skip = (page - 1) * limit;

    const where: any = {};
    if (filter.categoryId) {
      where.category = { id: filter.categoryId };
    }
    if (filter.search) {
      where.name = Like(`%${filter.search}%`);
    }
    if (filter.isFeatured !== undefined) {
      where.isFeatured = filter.isFeatured === 'true';
    }
    if (filter.brand) {
      where.brand = Like(`%${filter.brand}%`);
    }

    if (filter.minPrice && filter.maxPrice) {
      where.price = Between(filter.minPrice, filter.maxPrice);
    } else if (filter.minPrice) {
      where.price = MoreThanOrEqual(filter.minPrice);
    } else if (filter.maxPrice) {
      where.price = LessThanOrEqual(filter.maxPrice);
    }

    const order: any = {};
    if (filter.sort) {
      switch (filter.sort) {
        case 'price_asc':
          order.price = 'ASC';
          break;
        case 'price_desc':
          order.price = 'DESC';
          break;
        case 'popular':
          order.soldQuantity = 'DESC';
          break;
        case 'newest':
        default:
          order.createdAt = 'DESC';
          break;
      }
    } else {
      order.createdAt = 'DESC';
    }

    const [items, total] = await this.productsRepository.findAndCount({
      where,
      relations: ['category', 'images'],
      skip,
      take: limit,
      order,
    });

    return {
      items,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string): Promise<Product> {
    const product = await this.productsRepository.findOne({
      where: { id },
      relations: ['category', 'images'],
    });
    if (!product) throw new NotFoundException('Sản phẩm không tồn tại');
    return product;
  }

  async create(createProductDto: CreateProductDto): Promise<Product> {
    const product = this.productsRepository.create({
      ...createProductDto,
      category: createProductDto.categoryId ? ({ id: createProductDto.categoryId } as Category) : undefined,
    });
    return this.productsRepository.save(product);
  }

  async update(id: string, updateProductDto: UpdateProductDto): Promise<Product> {
    const product = await this.findOne(id);
    
    if (updateProductDto.categoryId !== undefined) {
      product.category = updateProductDto.categoryId ? ({ id: updateProductDto.categoryId } as Category) : undefined as any;
    }
    
    Object.assign(product, updateProductDto);
    return this.productsRepository.save(product);
  }

  async remove(id: string): Promise<void> {
    const product = await this.findOne(id);
    await this.productsRepository.remove(product);
  }
}
