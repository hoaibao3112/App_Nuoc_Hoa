import React, { useState, useEffect, useCallback } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import {
  ArrowLeft, Heart, ShoppingCart, Star, ChevronDown, ChevronUp,
  Minus, Plus, Shield, RotateCcw, Truck, Loader2
} from 'lucide-react'
import NavBar from '../shared/NavBar'
import Footer from '../shared/Footer'
import { productApi, cartApi, wishlistApi } from '../lib/shopApi'
import type { Product, Review } from '../types/product.types'

function StarRating({ rating, size = 14 }: { rating: number; size?: number }) {
  return (
    <span style={{ display: 'inline-flex', gap: 2 }}>
      {[1, 2, 3, 4, 5].map(s => (
        <Star
          key={s}
          size={size}
          fill={s <= Math.round(rating) ? '#f59e0b' : 'none'}
          stroke={s <= Math.round(rating) ? '#f59e0b' : '#d1d5db'}
        />
      ))}
    </span>
  )
}

// Mock product for demo when backend not available
const MOCK: Product = {
  id: '1',
  name: 'Violet Aurora Eau de Parfum',
  brand: 'LUXE EDITION',
  description: 'Một tuyệt phẩm hương hoa hiếm gặp — sự kết hợp hoàn hảo giữa hoa violet tươi mát và gỗ trầm ấm áp, tạo nên dấu ấn riêng biệt khó quên.',
  price: 2450000,
  discountPercent: 30,
  imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=500&q=80',
  images: [
    { id: '1', url: 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=500&q=80', order: 0 },
    { id: '2', url: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=500&q=80', order: 1 },
    { id: '3', url: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=500&q=80', order: 2 },
    { id: '4', url: 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?w=500&q=80', order: 3 },
  ],
  averageRating: 4.8,
  totalReviews: 128,
  category: { id: '1', name: 'Nữ', slug: 'nu' },
  sizes: ['30ml', '50ml', '100ml'],
  type: 'Eau de Parfum',
  scentNotes: {
    top: ['Cam Bergamot', 'Tiêu hồng'],
    middle: ['Hoa oải hương', 'Điểm sít'],
    base: ['Hổ phách', 'Xạ hương'],
  },
  ingredients: 'Alcohol Denat., Parfum (Fragrance), Aqua (Water), Benzyl Benzoate, Linalool, Citronellol',
  createdAt: new Date().toISOString(),
}

const MOCK_REVIEWS: Review[] = [
  { id: '1', rating: 5, comment: 'Mùi hương tuyệt vời, giữ mùi cực lâu trên 8 tiếng. Shop đóng gói rất ký càng và giao hàng nhanh.', user: { id: '1', fullName: 'Anh Nguyễn', avatarUrl: null }, createdAt: '2024-05-22T10:00:00Z' },
  { id: '2', rating: 5, comment: 'Tặng hương điểm vi rất rõ rệt, sang trọng. Thích hợp dùng di tiệc tối. Sẽ mua lại lần sau.', user: { id: '2', fullName: 'Minh Lan', avatarUrl: null }, createdAt: '2024-05-12T08:00:00Z' },
]

export default function ProductDetail() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()

  const [product, setProduct]       = useState<Product>(MOCK)
  const [reviews, setReviews]       = useState<Review[]>(MOCK_REVIEWS)
  const [loading, setLoading]       = useState(false)
  const [activeImg, setActiveImg]   = useState(0)
  const [selectedSize, setSelectedSize] = useState('50ml')
  const [qty, setQty]               = useState(1)
  const [wishlisted, setWishlisted] = useState(false)
  const [addingCart, setAddingCart] = useState(false)
  const [cartOk, setCartOk]         = useState(false)
  const [openDesc, setOpenDesc]     = useState(true)
  const [openScent, setOpenScent]   = useState(true)
  const [openIngr, setOpenIngr]     = useState(false)

  const salePrice = Math.round(product.price * (1 - product.discountPercent / 100))

  const fmt = (n: number) => n.toLocaleString('vi-VN') + 'đ'

  useEffect(() => {
    if (!id) return
    setLoading(true)
    Promise.all([productApi.detail(id), productApi.reviews(id)])
      .then(([p, r]) => {
        setProduct(p.data)
        setReviews(r.data.items)
        setSelectedSize(p.data.sizes?.[1] ?? p.data.sizes?.[0] ?? '50ml')
      })
      .catch(() => { /* use mock */ })
      .finally(() => setLoading(false))
  }, [id])

  const handleAddCart = useCallback(async () => {
    setAddingCart(true)
    try {
      await cartApi.add(product.id, qty, selectedSize)
      setCartOk(true)
      setTimeout(() => setCartOk(false), 2000)
    } catch {
      // not logged in — redirect to login
      navigate('/login')
    } finally {
      setAddingCart(false)
    }
  }, [product.id, qty, selectedSize, navigate])

  const handleWishlist = useCallback(async () => {
    try {
      await wishlistApi.toggle(product.id)
      setWishlisted(v => !v)
    } catch {
      navigate('/login')
    }
  }, [product.id, navigate])

  const ratingDist = [65, 19, 8, 4, 4]

  if (loading) return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      <Loader2 size={40} className="spin-loader" style={{ color: '#7c3aed', animation: 'spin 1s linear infinite' }} />
    </div>
  )

  return (
    <div style={{ minHeight: '100vh', background: '#faf5ff', fontFamily: 'Inter, sans-serif' }}>
      <NavBar />

      <main style={{ maxWidth: 960, margin: '0 auto', padding: '2rem 1rem 4rem' }}>
        {/* Back */}
        <button onClick={() => navigate(-1)} style={styles.backBtn}>
          <ArrowLeft size={16} /> Quay lại
        </button>

        {/* ── Top section ── */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '2.5rem', marginTop: '1.25rem' }}>

          {/* Gallery */}
          <div>
            <div style={styles.mainImg}>
              <img
                src={product.images?.[activeImg]?.url ?? product.imageUrl}
                alt={product.name}
                style={{ width: '100%', height: '100%', objectFit: 'cover' }}
              />
            </div>
            <div style={{ display: 'flex', gap: 10, marginTop: 12 }}>
              {product.images.map((img, i) => (
                <button
                  key={img.id}
                  onClick={() => setActiveImg(i)}
                  style={{
                    ...styles.thumbBtn,
                    borderColor: activeImg === i ? '#7c3aed' : '#e5e7eb',
                    boxShadow: activeImg === i ? '0 0 0 2px rgba(124,58,237,0.25)' : 'none',
                  }}
                >
                  <img src={img.url} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover', borderRadius: 8 }} />
                </button>
              ))}
            </div>
          </div>

          {/* Info */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1.1rem' }}>
            <div>
              <span style={styles.badge}>{product.brand}</span>
              <h1 style={styles.productTitle}>{product.name}</h1>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 6 }}>
                <StarRating rating={product.averageRating} />
                <span style={{ fontSize: 14, color: '#6b7280' }}>{product.averageRating} · {product.totalReviews} đánh giá</span>
              </div>
            </div>

            {/* Price */}
            <div>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
                <span style={styles.salePrice}>{fmt(salePrice)}</span>
                {product.discountPercent > 0 && (
                  <span style={styles.discountBadge}>-{product.discountPercent}%</span>
                )}
              </div>
              {product.discountPercent > 0 && (
                <span style={styles.originalPrice}>{fmt(product.price)}</span>
              )}
            </div>

            {/* Size */}
            <div>
              <p style={styles.fieldLabel}>CHỌN DUNG TÍCH</p>
              <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
                {product.sizes.map(s => (
                  <button
                    key={s}
                    onClick={() => setSelectedSize(s)}
                    style={{
                      ...styles.sizeBtn,
                      background: selectedSize === s ? 'linear-gradient(135deg,#7c3aed,#a855f7)' : 'white',
                      color: selectedSize === s ? 'white' : '#374151',
                      borderColor: selectedSize === s ? '#7c3aed' : '#e5e7eb',
                    }}
                  >
                    {s}
                  </button>
                ))}
              </div>
            </div>

            {/* Qty */}
            <div>
              <p style={styles.fieldLabel}>SỐ LƯỢNG</p>
              <div style={styles.qtyRow}>
                <button onClick={() => setQty(q => Math.max(1, q - 1))} style={styles.qtyBtn}><Minus size={14} /></button>
                <span style={styles.qtyNum}>{qty}</span>
                <button onClick={() => setQty(q => q + 1)} style={styles.qtyBtn}><Plus size={14} /></button>
              </div>
            </div>

            {/* CTA */}
            <div style={{ display: 'flex', gap: 12 }}>
              <button
                onClick={handleAddCart}
                disabled={addingCart}
                style={styles.addCartBtn}
              >
                {addingCart
                  ? <Loader2 size={16} style={{ animation: 'spin 1s linear infinite' }} />
                  : <ShoppingCart size={16} />
                }
                {cartOk ? 'Đã thêm ✓' : 'Thêm vào giỏ'}
              </button>
              <button onClick={handleWishlist} style={{ ...styles.wishBtn, borderColor: wishlisted ? '#f43f5e' : '#e5e7eb' }}>
                <Heart size={18} fill={wishlisted ? '#f43f5e' : 'none'} stroke={wishlisted ? '#f43f5e' : '#374151'} />
              </button>
            </div>

            {/* Badges */}
            <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap' }}>
              {[
                { icon: <Shield size={14} />, text: 'Miễn phí giao hàng' },
                { icon: <RotateCcw size={14} />, text: 'Đổi trả 30 ngày' },
                { icon: <Truck size={14} />, text: 'Giao nhanh 2 giờ' },
              ].map(b => (
                <div key={b.text} style={styles.featureBadge}>
                  <span style={{ color: '#7c3aed' }}>{b.icon}</span>
                  <span style={{ fontSize: 12, color: '#374151' }}>{b.text}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* ── Accordion sections ── */}
        <div style={{ marginTop: '2.5rem', display: 'flex', flexDirection: 'column', gap: 1 }}>
          {/* Description */}
          <Accordion open={openDesc} toggle={() => setOpenDesc(v => !v)} title="Mô tả sản phẩm">
            <p style={{ color: '#374151', lineHeight: 1.7, fontSize: 14 }}>{product.description}</p>
          </Accordion>

          {/* Scent notes */}
          {product.scentNotes && (
            <Accordion open={openScent} toggle={() => setOpenScent(v => !v)} title="Tầng hương">
              {(['top', 'middle', 'base'] as const).map((tier, i) => {
                const labels = ['HƯƠNG ĐẦU', 'HƯƠNG GIỮA', 'HƯƠNG CUỐI']
                return (
                  <div key={tier} style={{ marginBottom: 10 }}>
                    <p style={{ fontSize: 11, fontWeight: 700, color: '#9ca3af', letterSpacing: '0.05em', marginBottom: 6 }}>{labels[i]}</p>
                    <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
                      {product.scentNotes![tier].map(n => (
                        <span key={n} style={styles.scentTag}>{n}</span>
                      ))}
                    </div>
                  </div>
                )
              })}
            </Accordion>
          )}

          {/* Ingredients */}
          <Accordion open={openIngr} toggle={() => setOpenIngr(v => !v)} title="Thành phần">
            <p style={{ color: '#374151', lineHeight: 1.7, fontSize: 13 }}>{product.ingredients ?? 'Đang cập nhật...'}</p>
          </Accordion>
        </div>

        {/* ── Reviews ── */}
        <div style={{ marginTop: '3rem' }}>
          {/* Summary */}
          <div style={{ display: 'flex', alignItems: 'flex-start', gap: '3rem', marginBottom: '1.5rem', flexWrap: 'wrap' }}>
            <div>
              <div style={{ fontSize: '3.5rem', fontWeight: 800, color: '#7c3aed', lineHeight: 1 }}>
                {product.averageRating.toFixed(1)}
              </div>
              <StarRating rating={product.averageRating} size={18} />
              <p style={{ fontSize: 13, color: '#6b7280', marginTop: 4 }}>Dựa trên {product.totalReviews} đánh giá</p>
            </div>
            <div style={{ flex: 1, minWidth: 200 }}>
              {[5, 4, 3, 2, 1].map((star, i) => (
                <div key={star} style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 4 }}>
                  <span style={{ fontSize: 12, color: '#6b7280', minWidth: 28 }}>{star} sao</span>
                  <div style={{ flex: 1, height: 6, background: '#e5e7eb', borderRadius: 99, overflow: 'hidden' }}>
                    <div style={{ width: `${ratingDist[i]}%`, height: '100%', background: 'linear-gradient(90deg,#7c3aed,#a855f7)', borderRadius: 99, transition: 'width 0.6s ease' }} />
                  </div>
                  <span style={{ fontSize: 12, color: '#6b7280', minWidth: 24 }}>{ratingDist[i]}%</span>
                </div>
              ))}
            </div>
          </div>

          <button style={styles.reviewBtn}>Viết đánh giá</button>

          {/* Review cards */}
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill,minmax(300px,1fr))', gap: 16, marginTop: '1.5rem' }}>
            {reviews.map(r => (
              <div key={r.id} style={styles.reviewCard}>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10 }}>
                  <div style={styles.avatar}>
                    {r.user.fullName.slice(0, 2).toUpperCase()}
                  </div>
                  <div>
                    <p style={{ fontWeight: 600, fontSize: 14, color: '#111827', margin: 0 }}>{r.user.fullName}</p>
                    <p style={{ fontSize: 12, color: '#9ca3af', margin: 0 }}>
                      {new Date(r.createdAt).toLocaleDateString('vi-VN', { day: 'numeric', month: 'long', year: 'numeric' })}
                    </p>
                  </div>
                  <div style={{ marginLeft: 'auto' }}>
                    <StarRating rating={r.rating} size={13} />
                  </div>
                </div>
                <p style={{ fontSize: 14, color: '#374151', lineHeight: 1.6, margin: 0 }}>{r.comment}</p>
              </div>
            ))}
          </div>
        </div>
      </main>

      <Footer />

      <style>{`
        @keyframes spin { to { transform: rotate(360deg); } }
        @media (max-width: 640px) {
          main > div:nth-child(2) { grid-template-columns: 1fr !important; }
        }
      `}</style>
    </div>
  )
}

function Accordion({
  title, open, toggle, children,
}: {
  title: string; open: boolean; toggle: () => void; children: React.ReactNode
}) {
  return (
    <div style={{ background: 'white', borderRadius: 12, marginBottom: 4, overflow: 'hidden', border: '1px solid #f3e8ff' }}>
      <button
        onClick={toggle}
        style={{ width: '100%', display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '1rem 1.25rem', background: 'none', border: 'none', cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset' }}
      >
        <span style={{ fontWeight: 600, fontSize: 15, color: '#111827' }}>{title}</span>
        {open ? <ChevronUp size={18} color="#7c3aed" /> : <ChevronDown size={18} color="#9ca3af" />}
      </button>
      {open && <div style={{ padding: '0 1.25rem 1.25rem' }}>{children}</div>}
    </div>
  )
}

const styles: Record<string, React.CSSProperties> = {
  backBtn: {
    display: 'inline-flex', alignItems: 'center', gap: 6,
    background: 'white', border: '1px solid #e5e7eb', borderRadius: 10,
    padding: '0.45rem 1rem', fontSize: 14, cursor: 'pointer',
    color: '#374151', fontFamily: 'inherit', minHeight: 'unset',
    transition: 'all 0.15s',
  },
  mainImg: {
    borderRadius: 16, overflow: 'hidden', aspectRatio: '1',
    background: '#f3e8ff', boxShadow: '0 4px 24px rgba(124,58,237,0.1)',
  },
  thumbBtn: {
    width: 72, height: 72, borderRadius: 10, overflow: 'hidden',
    border: '2px solid', cursor: 'pointer', background: 'none',
    padding: 0, flexShrink: 0, transition: 'all 0.15s', minHeight: 'unset',
  },
  badge: {
    display: 'inline-block', fontSize: 11, fontWeight: 700, letterSpacing: '0.06em',
    color: '#7c3aed', background: '#f3e8ff', borderRadius: 6,
    padding: '0.2rem 0.6rem', marginBottom: 8,
  },
  productTitle: {
    fontFamily: 'Playfair Display, serif', fontSize: '1.75rem', fontWeight: 700,
    color: '#0B1220', margin: 0, lineHeight: 1.25,
  },
  salePrice: {
    fontFamily: 'Playfair Display, serif', fontSize: '1.75rem', fontWeight: 800,
    background: 'linear-gradient(135deg,#7c3aed,#a855f7)',
    WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text',
  },
  discountBadge: {
    background: '#fef2f2', color: '#e11d48', borderRadius: 6,
    padding: '0.2rem 0.5rem', fontSize: 13, fontWeight: 700,
  },
  originalPrice: { color: '#9ca3af', textDecoration: 'line-through', fontSize: 14 },
  fieldLabel: { fontSize: 11, fontWeight: 700, letterSpacing: '0.08em', color: '#9ca3af', marginBottom: 8, marginTop: 0 },
  sizeBtn: {
    padding: '0.5rem 1.25rem', border: '1.5px solid', borderRadius: 10,
    cursor: 'pointer', fontWeight: 600, fontSize: 14, fontFamily: 'inherit',
    transition: 'all 0.15s', minHeight: 'unset',
  },
  qtyRow: { display: 'flex', alignItems: 'center', gap: 16 },
  qtyBtn: {
    width: 36, height: 36, borderRadius: 10, border: '1.5px solid #e5e7eb',
    background: 'white', cursor: 'pointer', display: 'flex', alignItems: 'center',
    justifyContent: 'center', color: '#374151', minHeight: 'unset', transition: 'all 0.15s',
  },
  qtyNum: { fontWeight: 700, fontSize: 18, minWidth: 24, textAlign: 'center', color: '#111827' },
  addCartBtn: {
    flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
    background: 'linear-gradient(135deg,#7c3aed,#a855f7)', color: 'white',
    border: 'none', borderRadius: 12, padding: '0.875rem', fontWeight: 600,
    fontSize: 15, cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset',
    boxShadow: '0 4px 14px rgba(124,58,237,0.4)', transition: 'all 0.2s',
  },
  wishBtn: {
    width: 52, height: 52, display: 'flex', alignItems: 'center', justifyContent: 'center',
    background: 'white', border: '1.5px solid', borderRadius: 12, cursor: 'pointer',
    minHeight: 'unset', flexShrink: 0, transition: 'all 0.15s',
  },
  featureBadge: { display: 'flex', alignItems: 'center', gap: 6 },
  scentTag: {
    background: '#f3e8ff', color: '#7c3aed', borderRadius: 20,
    padding: '0.25rem 0.75rem', fontSize: 13, fontWeight: 500,
  },
  reviewBtn: {
    border: '1.5px solid #7c3aed', color: '#7c3aed', background: 'transparent',
    borderRadius: 12, padding: '0.625rem 1.5rem', fontWeight: 600, fontSize: 14,
    cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset', transition: 'all 0.15s',
  },
  reviewCard: {
    background: 'white', borderRadius: 14, padding: '1rem 1.25rem',
    boxShadow: '0 2px 8px rgba(0,0,0,0.05)', border: '1px solid #f3e8ff',
  },
  avatar: {
    width: 40, height: 40, borderRadius: '50%', background: 'linear-gradient(135deg,#7c3aed,#a855f7)',
    color: 'white', display: 'flex', alignItems: 'center', justifyContent: 'center',
    fontWeight: 700, fontSize: 13, flexShrink: 0,
  },
}
