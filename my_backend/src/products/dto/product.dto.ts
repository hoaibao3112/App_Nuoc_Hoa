import { IsString, IsNumber, IsOptional, Min } from 'class-validator';

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

  @IsOptional()
  isFeatured?: boolean;

  @IsOptional()
  @IsNumber()
  discountPercent?: number;
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

  @IsOptional()
  isFeatured?: boolean;

  @IsOptional()
  @IsNumber()
  discountPercent?: number;
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
}
