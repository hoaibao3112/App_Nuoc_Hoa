import {
  IsString,
  IsNumber,
  IsOptional,
  Min,
  IsBoolean,
  IsInt,
} from 'class-validator';

export class CreateProductDto {
  @IsString()
  name: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  @Min(0)
  price: number;

  @IsString()
  @IsOptional()
  categoryId?: string;

  @IsString()
  @IsOptional()
  imageUrl?: string;

  @IsBoolean()
  @IsOptional()
  isFeatured?: boolean;

  @IsOptional()
  @IsNumber()
  discountPercent?: number;

  @IsString()
  @IsOptional()
  brand?: string;

  @IsInt()
  @Min(0)
  @IsOptional()
  stockQuantity?: number;
}

export class UpdateProductDto {
  @IsString()
  @IsOptional()
  name?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  @Min(0)
  @IsOptional()
  price?: number;

  @IsString()
  @IsOptional()
  categoryId?: string;

  @IsString()
  @IsOptional()
  imageUrl?: string;

  @IsBoolean()
  @IsOptional()
  isFeatured?: boolean;

  @IsOptional()
  @IsNumber()
  discountPercent?: number;

  @IsString()
  @IsOptional()
  brand?: string;

  @IsInt()
  @Min(0)
  @IsOptional()
  stockQuantity?: number;
}

export class FilterProductDto {
  @IsOptional()
  page?: string;

  @IsOptional()
  limit?: string;

  @IsOptional()
  categoryId?: string;

  @IsOptional()
  search?: string;

  @IsOptional()
  isFeatured?: string; // 'true' | 'false'
  @IsOptional()
  brand?: string;

  @IsOptional()
  minPrice?: number;

  @IsOptional()
  maxPrice?: number;

  @IsOptional()
  sort?: 'price_asc' | 'price_desc' | 'newest' | 'popular';
}
