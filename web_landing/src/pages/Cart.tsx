import React, { useState, useEffect, useCallback } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Trash2, Minus, Plus, ShoppingBag, Tag, Truck, Shield, Loader2 } from 'lucide-react'
import NavBar from '../shared/NavBar'
import Footer from '../shared/Footer'
import { cartApi } from '../lib/shopApi'
import type { Cart, CartItem } from '../types/product.types'
import { useAuth } from '../contexts/AuthContext'

const fmt = (n: number) => n.toLocaleString('vi-VN') + 'đ'

// Mock data
const MOCK_CART: Cart = {
  items: [
    {
      id: '1',
      product: {
        id: 'p1', name: 'Midnight Lavender', brand: 'ScentVibe',
        description: '', price: 2450000, discountPercent: 0,
        imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=200&q=80',
        images: [], averageRating: 4.8, totalReviews: 100,
        category: { id: '1', name: 'Nữ', slug: 'nu' },
        sizes: ['50ml'], type: 'Eau de Parfum', createdAt: '',
      },
      quantity: 1, size: '50ml', unitPrice: 2450000,
    },
    {
      id: '2',
      product: {
        id: 'p2', name: 'Urban Oasis', brand: 'ScentVibe',
        description: '', price: 3200000, discountPercent: 0,
        imageUrl: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=200&q=80',
        images: [], averageRating: 4.6, totalReviews: 80,
        category: { id: '2', name: 'Nam', slug: 'nam' },
        sizes: ['100ml'], type: 'Eau de Toilette', createdAt: '',
      },
      quantity: 1, size: '100ml', unitPrice: 3200000,
    },
    {
      id: '3',
      product: {
        id: 'p3', name: 'Velvet Oud', brand: 'ScentVibe',
        description: '', price: 1850000, discountPercent: 0,
        imageUrl: 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?w=200&q=80',
        images: [], averageRating: 4.9, totalReviews: 200,
        category: { id: '3', name: 'Unisex', slug: 'unisex' },
        sizes: ['30ml'], type: 'Parfum Extrait', createdAt: '',
      },
      quantity: 1, size: '30ml', unitPrice: 1850000,
    },
  ],
  total: 7500000,
}

export default function CartPage() {
  const navigate = useNavigate()
  const { state: authState } = useAuth()

  const [cart, setCart]           = useState<Cart>(MOCK_CART)
  const [loading, setLoading]     = useState(false)
  const [voucher, setVoucher]     = useState('')
  const [discount, setDiscount]   = useState(250000)
  const [updatingId, setUpdatingId] = useState<string | null>(null)

  const FREE_SHIP_THRESHOLD = 2000000

  useEffect(() => {
    if (!authState.isAuthenticated) return
    setLoading(true)
    cartApi.get()
      .then(r => setCart(r.data))
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [authState.isAuthenticated])

  const subtotal  = cart.items.reduce((s, i) => s + i.unitPrice * i.quantity, 0)
  const shipping  = subtotal >= FREE_SHIP_THRESHOLD ? 0 : 30000
  const total     = subtotal + shipping - discount

  const handleQty = useCallback(async (item: CartItem, delta: number) => {
    const newQty = item.quantity + delta
    if (newQty < 1) return
    setUpdatingId(item.id)
    try {
      await cartApi.update(item.id, newQty)
    } catch {}
    setCart(c => ({
      ...c,
      items: c.items.map(i => i.id === item.id ? { ...i, quantity: newQty } : i),
    }))
    setUpdatingId(null)
  }, [])

  const handleRemove = useCallback(async (itemId: string) => {
    setUpdatingId(itemId)
    try { await cartApi.remove(itemId) } catch {}
    setCart(c => ({ ...c, items: c.items.filter(i => i.id !== itemId) }))
    setUpdatingId(null)
  }, [])

  if (loading) return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#faf5ff' }}>
      <Loader2 size={36} style={{ color: '#7c3aed', animation: 'spin 1s linear infinite' }} />
    </div>
  )

  return (
    <div style={{ minHeight: '100vh', background: '#faf5ff', fontFamily: 'Inter, sans-serif' }}>
      <NavBar />

      <main style={{ maxWidth: 1000, margin: '0 auto', padding: '2rem 1rem 4rem' }}>
        <h1 style={{ fontFamily: 'Playfair Display, serif', fontSize: '1.75rem', fontWeight: 700, color: '#0B1220', marginBottom: '1.5rem' }}>
          Giỏ hàng của bạn
          <span style={{ fontSize: '1rem', fontFamily: 'Inter, sans-serif', fontWeight: 500, color: '#7c3aed', marginLeft: 8 }}>
            ({cart.items.length} sản phẩm)
          </span>
        </h1>

        {cart.items.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '5rem 1rem', background: 'white', borderRadius: 20 }}>
            <ShoppingBag size={60} style={{ color: '#d8b4fe', margin: '0 auto 1rem' }} />
            <p style={{ fontSize: 18, fontWeight: 600, color: '#374151' }}>Giỏ hàng đang trống</p>
            <p style={{ color: '#9ca3af', marginBottom: '1.5rem' }}>Hãy khám phá những mùi hương tuyệt vời</p>
            <Link to="/products" style={btnLinkStyle}>Khám phá ngay</Link>
          </div>
        ) : (
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 340px', gap: '1.5rem', alignItems: 'start' }}>
            {/* Items */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              {cart.items.map(item => (
                <div key={item.id} style={itemCardStyle}>
                  <img
                    src={item.product.imageUrl}
                    alt={item.product.name}
                    style={{ width: 90, height: 90, objectFit: 'cover', borderRadius: 12, flexShrink: 0, background: '#f3e8ff' }}
                  />
                  <div style={{ flex: 1 }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                      <div>
                        <Link
                          to={`/products/${item.product.id}`}
                          style={{ fontWeight: 600, fontSize: 15, color: '#111827', textDecoration: 'none' }}
                        >
                          {item.product.name}
                        </Link>
                        <span style={tagStyle}>{item.size} · {item.product.type}</span>
                      </div>
                      <button
                        onClick={() => handleRemove(item.id)}
                        disabled={updatingId === item.id}
                        style={removeBtn}
                        aria-label="Xóa"
                      >
                        <Trash2 size={15} />
                      </button>
                    </div>
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: 14 }}>
                      <div style={qtyWrap}>
                        <button onClick={() => handleQty(item, -1)} disabled={updatingId === item.id} style={qtyBtnS}><Minus size={13} /></button>
                        <span style={{ fontWeight: 700, minWidth: 20, textAlign: 'center', fontSize: 15 }}>{item.quantity}</span>
                        <button onClick={() => handleQty(item, +1)} disabled={updatingId === item.id} style={qtyBtnS}><Plus size={13} /></button>
                      </div>
                      <span style={{ fontWeight: 700, fontSize: 16, background: 'linear-gradient(135deg,#7c3aed,#a855f7)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>
                        {fmt(item.unitPrice * item.quantity)}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Summary */}
            <div style={summaryCard}>
              <h2 style={{ fontWeight: 700, fontSize: 17, color: '#111827', margin: '0 0 1.25rem' }}>Tóm tắt đơn hàng</h2>

              {/* Voucher */}
              <div style={{ display: 'flex', gap: 8, marginBottom: '1.25rem' }}>
                <div style={{ flex: 1, display: 'flex', alignItems: 'center', background: '#f9fafb', borderRadius: 10, border: '1.5px solid #e5e7eb', padding: '0 12px', gap: 8 }}>
                  <Tag size={14} style={{ color: '#9ca3af', flexShrink: 0 }} />
                  <input
                    value={voucher}
                    onChange={e => setVoucher(e.target.value)}
                    placeholder="Mã giảm giá"
                    style={{ border: 'none', background: 'transparent', outline: 'none', fontSize: 14, width: '100%', fontFamily: 'inherit' }}
                  />
                </div>
                <button style={applyBtn}>Áp dụng</button>
              </div>

              {/* Rows */}
              {[
                { label: 'Tạm tính', value: fmt(subtotal) },
                { label: 'Giảm giá', value: `-${fmt(discount)}`, red: true },
                { label: 'Phí ship', value: shipping === 0 ? 'Miễn phí' : fmt(shipping), green: shipping === 0 },
              ].map(r => (
                <div key={r.label} style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 10, fontSize: 14 }}>
                  <span style={{ color: '#6b7280' }}>{r.label}</span>
                  <span style={{ fontWeight: 600, color: r.red ? '#e11d48' : r.green ? '#10b981' : '#111827' }}>{r.value}</span>
                </div>
              ))}

              <div style={{ borderTop: '1px dashed #e5e7eb', margin: '1rem 0', paddingTop: '1rem', display: 'flex', justifyContent: 'space-between' }}>
                <span style={{ fontWeight: 700, fontSize: 16, color: '#111827' }}>Tổng cộng</span>
                <span style={{ fontWeight: 800, fontSize: 20, background: 'linear-gradient(135deg,#7c3aed,#a855f7)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>
                  {fmt(total)}
                </span>
              </div>

              <button
                id="checkout-btn"
                onClick={() => navigate('/checkout')}
                style={checkoutBtn}
              >
                Tiến hành thanh toán
              </button>

              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 6, marginTop: 12 }}>
                <Shield size={13} style={{ color: '#9ca3af' }} />
                <span style={{ fontSize: 12, color: '#9ca3af' }}>Thanh toán bảo mật SSL</span>
              </div>

              {/* Free ship hint */}
              {shipping > 0 && (
                <div style={{ marginTop: 16, background: '#f3e8ff', borderRadius: 10, padding: '0.75rem 1rem', display: 'flex', alignItems: 'center', gap: 8 }}>
                  <Truck size={15} style={{ color: '#7c3aed', flexShrink: 0 }} />
                  <p style={{ fontSize: 13, color: '#7c3aed', margin: 0, lineHeight: 1.4 }}>
                    Mua thêm <strong>{fmt(FREE_SHIP_THRESHOLD - subtotal)}</strong> để được miễn phí vận chuyển!
                  </p>
                </div>
              )}
            </div>
          </div>
        )}
      </main>

      <Footer />
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  )
}

const itemCardStyle: React.CSSProperties = {
  background: 'white', borderRadius: 16, padding: '1rem 1.25rem',
  display: 'flex', gap: 16, alignItems: 'center',
  boxShadow: '0 2px 8px rgba(0,0,0,0.05)', border: '1px solid #f3e8ff',
}
const tagStyle: React.CSSProperties = {
  display: 'inline-block', fontSize: 12, color: '#7c3aed', background: '#f3e8ff',
  borderRadius: 6, padding: '0.15rem 0.5rem', marginTop: 4,
}
const removeBtn: React.CSSProperties = {
  background: 'none', border: 'none', cursor: 'pointer', color: '#d1d5db',
  padding: 4, minHeight: 'unset', borderRadius: 6, flexShrink: 0,
  transition: 'color 0.15s',
}
const qtyWrap: React.CSSProperties = {
  display: 'flex', alignItems: 'center', gap: 12,
  background: '#f9fafb', borderRadius: 10, padding: '0.3rem 0.75rem',
  border: '1.5px solid #e5e7eb',
}
const qtyBtnS: React.CSSProperties = {
  background: 'none', border: 'none', cursor: 'pointer', color: '#374151',
  display: 'flex', alignItems: 'center', padding: 2, minHeight: 'unset',
}
const summaryCard: React.CSSProperties = {
  background: 'white', borderRadius: 20, padding: '1.5rem',
  boxShadow: '0 4px 20px rgba(124,58,237,0.08)', border: '1px solid #f3e8ff',
  position: 'sticky', top: 100,
}
const applyBtn: React.CSSProperties = {
  background: 'linear-gradient(135deg,#7c3aed,#a855f7)', color: 'white',
  border: 'none', borderRadius: 10, padding: '0 1rem', fontWeight: 600,
  fontSize: 13, cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset', flexShrink: 0,
}
const checkoutBtn: React.CSSProperties = {
  width: '100%', padding: '0.875rem', background: 'linear-gradient(135deg,#7c3aed,#a855f7)',
  color: 'white', border: 'none', borderRadius: 14, fontWeight: 700, fontSize: 15,
  cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset',
  boxShadow: '0 4px 14px rgba(124,58,237,0.4)', transition: 'all 0.2s',
}
const btnLinkStyle: React.CSSProperties = {
  display: 'inline-block', background: 'linear-gradient(135deg,#7c3aed,#a855f7)',
  color: 'white', borderRadius: 12, padding: '0.75rem 2rem', fontWeight: 600,
  fontSize: 15, textDecoration: 'none',
}
