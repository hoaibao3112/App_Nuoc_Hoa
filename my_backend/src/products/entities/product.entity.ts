import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { Category } from '../../categories/entities/category.entity';
import { ProductImage } from './product-image.entity';

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: true })
  name: string;

  @Column('text', { nullable: true })
  description: string;

  @Column('decimal', { precision: 10, scale: 2, nullable: true })
  price: number;

  @Column({ nullable: true })
  imageUrl: string;

  @OneToMany(() => ProductImage, (image) => image.product, { cascade: true })
  images: ProductImage[];

  // Nhiều sản phẩm thuộc về một danh mục
  @ManyToOne(() => Category, (category) => category.products, { onDelete: 'SET NULL' })
  category: Category;

  @Column({ default: false })
  isFeatured: boolean;

  @Column('decimal', { precision: 5, scale: 2, nullable: true })
  discountPercent: number;

  @Column({ nullable: true })
  brand: string;

  @Column('int', { default: 0 })
  stockQuantity: number;

  @Column('int', { default: 0 })
  soldQuantity: number;

  @Column('decimal', { precision: 2, scale: 1, default: 0 })
  averageRating: number;

  @Column('int', { default: 0 })
  totalReviews: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
