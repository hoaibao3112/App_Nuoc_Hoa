import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('vouchers')
export class Voucher {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  code: string;

  @Column()
  discountType: string; // 'PERCENT' or 'FIXED'

  @Column('decimal', { precision: 10, scale: 2 })
  discountValue: number;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  minOrderValue: number;

  @Column('decimal', { precision: 10, scale: 2, nullable: true })
  maxDiscount: number;

  @Column('int', { default: 100 })
  usageLimit: number;

  @Column('int', { default: 0 })
  usedCount: number;

  @Column({ nullable: true })
  expiryDate: Date;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
