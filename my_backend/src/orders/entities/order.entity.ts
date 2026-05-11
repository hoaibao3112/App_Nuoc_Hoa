import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { OrderItem } from './order-item.entity';

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  user: User;

  @Column('decimal', { precision: 10, scale: 2 })
  totalAmount: number;

  @Column({ nullable: true })
  receiverName: string;

  @Column({ nullable: true })
  receiverPhone: string;

  @Column('text', { nullable: true })
  shippingAddress: string;

  @Column({ default: 'COD' })
  paymentMethod: string; // COD, VNPAY, MOMO

  @Column({ default: 'PENDING' })
  paymentStatus: string; // PENDING, PAID, FAILED

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  shippingFee: number;

  @Column({ default: 'PENDING' }) // PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED
  status: string;

  @OneToMany(() => OrderItem, (item) => item.order, { cascade: true })
  items: OrderItem[];

  @CreateDateColumn()
  createdAt: Date;
}
