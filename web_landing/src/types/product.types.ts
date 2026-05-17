export interface Category {
  id: string
  name: string
  slug: string
}

export interface ProductImage {
  id: string
  url: string
  order: number
}

export interface Product {
  id: string
  name: string
  brand: string
  description: string
  price: number
  discountPercent: number
  imageUrl: string
  images: ProductImage[]
  averageRating: number
  totalReviews: number
  category: Category
  sizes: string[]         // e.g. ['30ml','50ml','100ml']
  type: string            // Eau de Parfum, EDT...
  scentNotes?: {
    top: string[]
    middle: string[]
    base: string[]
  }
  ingredients?: string
  createdAt: string
}

export interface Review {
  id: string
  rating: number
  comment: string
  user: { id: string; fullName: string; avatarUrl: string | null }
  createdAt: string
}

export interface CartItem {
  id: string
  product: Product
  quantity: number
  size: string
  unitPrice: number
}

export interface Cart {
  items: CartItem[]
  total: number
}

export interface Address {
  id: string
  fullName: string
  phone: string
  addressLine: string
  ward: string
  district: string
  city: string
  isDefault: boolean
}

export interface Order {
  id: string
  status: 'PENDING' | 'PROCESSING' | 'SHIPPING' | 'COMPLETED' | 'CANCELLED'
  totalAmount: number
  items: Array<{
    id: string
    productName: string
    productImage: string
    quantity: number
    size: string
    unitPrice: number
  }>
  address: Address
  paymentMethod: 'COD' | 'BANK_TRANSFER'
  note?: string
  createdAt: string
}
