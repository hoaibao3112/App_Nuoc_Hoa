import { IsString, IsNotEmpty } from 'class-validator';

export class ToggleWishlistDto {
  @IsString()
  @IsNotEmpty()
  productId: string;
}
