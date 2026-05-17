import type { ApiResponse } from '../types/auth.types'
import type { Product, Cart, CartItem, Address, Order, Review } from '../types/product.types'

const BASE_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:3000/api'

async function request<T>(path: string, options: RequestInit = {}): Promise<ApiResponse<T>> {
  const token = localStorage.getItem('accessToken')
  const res = await fetch(`${BASE_URL}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  })
  const json: ApiResponse<T> = await res.json()
  if (!res.ok) throw new Error(json.message ?? `HTTP ${res.status}`)
  return json
}

// ── Products ──────────────────────────────────────────────────────────────────
export const productApi = {
  list: (params?: {
    categoryId?: string
    search?: string
    page?: number
    limit?: number
    sort?: string
  }) => {
    const q = new URLSearchParams()
    if (params?.categoryId) q.set('categoryId', params.categoryId)
    if (params?.search) q.set('search', params.search)
    if (params?.page) q.set('page', String(params.page))
    if (params?.limit) q.set('limit', String(params.limit))
    if (params?.sort) q.set('sort', params.sort)
    return request<{ items: Product[]; total: number; page: number; totalPages: number }>(
      `/products?${q}`
    )
  },
  detail: (id: string) => request<Product>(`/products/${id}`),
  reviews: (id: string) => request<{ items: Review[]; total: number }>(`/products/${id}/reviews`),
  categories: () => request<{ id: string; name: string; slug: string }[]>('/categories'),
}

// ── Cart ──────────────────────────────────────────────────────────────────────
export const cartApi = {
  get: () => request<Cart>('/cart'),
  add: (productId: string, quantity: number, size: string) =>
    request<CartItem>('/cart/add', {
      method: 'POST',
      body: JSON.stringify({ productId, quantity, size }),
    }),
  update: (itemId: string, quantity: number) =>
    request<CartItem>(`/cart/update/${itemId}`, {
      method: 'PATCH',
      body: JSON.stringify({ quantity }),
    }),
  remove: (itemId: string) =>
    request<void>(`/cart/remove/${itemId}`, { method: 'DELETE' }),
}

// ── Orders ────────────────────────────────────────────────────────────────────
export const orderApi = {
  list: () => request<Order[]>('/orders'),
  detail: (id: string) => request<Order>(`/orders/${id}`),
  create: (payload: {
    addressId: string
    paymentMethod: 'COD' | 'BANK_TRANSFER'
    note?: string
    voucherCode?: string
  }) =>
    request<Order>('/orders', { method: 'POST', body: JSON.stringify(payload) }),
}

// ── Addresses ─────────────────────────────────────────────────────────────────
export const addressApi = {
  list: () => request<Address[]>('/addresses'),
  create: (payload: Omit<Address, 'id'>) =>
    request<Address>('/addresses', { method: 'POST', body: JSON.stringify(payload) }),
}

// ── Wishlists ─────────────────────────────────────────────────────────────────
export const wishlistApi = {
  list: () => request<Product[]>('/wishlists'),
  toggle: (productId: string) =>
    request<{ added: boolean }>('/wishlists', {
      method: 'POST',
      body: JSON.stringify({ productId }),
    }),
}
