import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { Category } from '../../categories/entities/category.entity';

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

  @CreateDateColumn()

  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
