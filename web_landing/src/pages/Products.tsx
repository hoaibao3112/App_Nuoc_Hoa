import React, { useState, useEffect, useCallback } from 'react'
import { Link } from 'react-router-dom'
import { Search, Heart, Star, SlidersHorizontal, X, Loader2 } from 'lucide-react'
import NavBar from '../shared/NavBar'
import Footer from '../shared/Footer'
import { productApi, wishlistApi } from '../lib/shopApi'
import type { Product } from '../types/product.types'

const fmt = (n: number) => n.toLocaleString('vi-VN') + 'đ'

// Mock products for demo
const MOCK_PRODUCTS: Product[] = [
  { id: '1', name: 'Midnight Essence', brand: 'BLEU DE NOIR', description: '', price: 450000, discountPercent: 30, imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=400&q=80', images: [], averageRating: 4.8, totalReviews: 124, category: { id: '2', name: 'Nam', slug: 'nam' }, sizes: ['50ml', '100ml'], type: 'Eau de Parfum', createdAt: '' },
  { id: '2', name: 'Rosé Petal Bliss', brand: 'FLORAL BLOOM', description: '', price: 390000, discountPercent: 10, imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=400&q=80', images: [], averageRating: 4.7, totalReviews: 89, category: { id: '1', name: 'Nữ', slug: 'nu' }, sizes: ['30ml', '50ml'], type: 'Eau de Parfum', createdAt: '' },
  { id: '3', name: 'Neon Horizon', brand: 'URBAN EDGE', description: '', price: 520000, discountPercent: 40, imageUrl: 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?w=400&q=80', images: [], averageRating: 4.9, totalReviews: 210, category: { id: '3', name: 'Unisex', slug: 'unisex' }, sizes: ['50ml', '100ml'], type: 'Eau de Parfum', createdAt: '' },
  { id: '4', name: 'Violet Aurora', brand: 'LUXE EDITION', description: '', price: 2450000, discountPercent: 30, imageUrl: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=400&q=80', images: [], averageRating: 4.8, totalReviews: 128, category: { id: '1', name: 'Nữ', slug: 'nu' }, sizes: ['30ml', '50ml', '100ml'], type: 'Eau de Parfum', createdAt: '' },
  { id: '5', name: 'Cedar Storm', brand: 'WOODY', description: '', price: 680000, discountPercent: 0, imageUrl: 'https://images.unsplash.com/photo-1566977776052-6e61e35bf9be?w=400&q=80', images: [], averageRating: 4.5, totalReviews: 56, category: { id: '2', name: 'Nam', slug: 'nam' }, sizes: ['50ml', '100ml'], type: 'Eau de Toilette', createdAt: '' },
  { id: '6', name: 'Fresh Citrus Breeze', brand: 'FRESH', description: '', price: 320000, discountPercent: 15, imageUrl: 'https://images.unsplash.com/photo-1595535873420-a599195b3f4a?w=400&q=80', images: [], averageRating: 4.3, totalReviews: 42, category: { id: '3', name: 'Unisex', slug: 'unisex' }, sizes: ['30ml', '50ml'], type: 'Eau de Cologne', createdAt: '' },
]

const CATEGORIES = [
  { id: '', label: 'Tất cả' },
  { id: '1', label: 'Nữ' },
  { id: '2', label: 'Nam' },
  { id: '3', label: 'Unisex' },
  { id: 'best', label: 'Best Seller' },
  { id: 'new', label: 'Mới về' },
]

const SORTS = [
  { value: '', label: 'Mặc định' },
  { value: 'price_asc', label: 'Giá tăng dần' },
  { value: 'price_desc', label: 'Giá giảm dần' },
  { value: 'rating', label: 'Đánh giá cao' },
  { value: 'newest', label: 'Mới nhất' },
]

function ProductCard({ product }: { product: Product }) {
  const [wishlisted, setWishlisted] = useState(false)
  const salePrice = Math.round(product.price * (1 - product.discountPercent / 100))

  return (
    <div style={cardWrapper}>
      <Link to={`/products/${product.id}`} style={{ textDecoration: 'none', color: 'inherit' }}>
        <div style={imgBox}>
          <img src={product.imageUrl} alt={product.name} style={imgStyle} />
          {product.discountPercent > 0 && (
            <span style={discountTag}>-{product.discountPercent}%</span>
          )}
        </div>
        <div style={{ padding: '0.875rem 1rem 0.75rem' }}>
          <p style={{ fontSize: 11, fontWeight: 700, color: '#7c3aed', letterSpacing: '0.06em', margin: '0 0 4px' }}>
            {product.brand}
          </p>
          <h3 style={{ fontSize: 15, fontWeight: 700, color: '#111827', margin: '0 0 6px', lineHeight: 1.3 }}>
            {product.name}
          </h3>
          <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginBottom: 8 }}>
            {[1, 2, 3, 4, 5].map(s => (
              <Star key={s} size={11} fill={s <= Math.round(product.averageRating) ? '#f59e0b' : 'none'} stroke={s <= Math.round(product.averageRating) ? '#f59e0b' : '#d1d5db'} />
            ))}
            <span style={{ fontSize: 12, color: '#9ca3af' }}>({product.totalReviews})</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 8 }}>
            {product.discountPercent > 0 && (
              <span style={{ fontSize: 13, color: '#9ca3af', textDecoration: 'line-through' }}>{fmt(product.price)}</span>
            )}
            <span style={{ fontSize: 16, fontWeight: 800, background: 'linear-gradient(135deg,#7c3aed,#a855f7)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>
              {fmt(salePrice)}
            </span>
          </div>
        </div>
      </Link>

      {/* Wishlist button */}
      <button
        onClick={(e) => { e.preventDefault(); setWishlisted(v => !v) }}
        style={{ ...wishBtn, borderColor: wishlisted ? '#f43f5e' : 'transparent', background: 'white' }}
        aria-label="Yêu thích"
      >
        <Heart size={15} fill={wishlisted ? '#f43f5e' : 'none'} stroke={wishlisted ? '#f43f5e' : '#9ca3af'} />
      </button>
    </div>
  )
}

export default function Products() {
  const [products, setProducts] = useState<Product[]>(MOCK_PRODUCTS)
  const [loading, setLoading]   = useState(false)
  const [search, setSearch]     = useState('')
  const [catId, setCatId]       = useState('')
  const [sort, setSort]         = useState('')
  const [showFilter, setShowFilter] = useState(false)
  const [page, setPage]         = useState(1)
  const [totalPages, setTotalPages] = useState(1)

  const fetchProducts = useCallback(async () => {
    setLoading(true)
    try {
      const res = await productApi.list({ categoryId: catId || undefined, search: search || undefined, sort: sort || undefined, page, limit: 9 })
      setProducts(res.data.items)
      setTotalPages(res.data.totalPages)
    } catch {
      // use mock + filter locally
      let filtered = MOCK_PRODUCTS
      if (search) filtered = filtered.filter(p => p.name.toLowerCase().includes(search.toLowerCase()))
      if (catId && catId !== 'best' && catId !== 'new') filtered = filtered.filter(p => p.category.id === catId)
      if (sort === 'price_asc') filtered = [...filtered].sort((a, b) => a.price - b.price)
      if (sort === 'price_desc') filtered = [...filtered].sort((a, b) => b.price - a.price)
      if (sort === 'rating') filtered = [...filtered].sort((a, b) => b.averageRating - a.averageRating)
      setProducts(filtered)
      setTotalPages(1)
    } finally {
      setLoading(false)
    }
  }, [catId, search, sort, page])

  useEffect(() => {
    const timer = setTimeout(fetchProducts, 300)
    return () => clearTimeout(timer)
  }, [fetchProducts])

  return (
    <div style={{ minHeight: '100vh', background: '#faf5ff', fontFamily: 'Inter, sans-serif' }}>
      <NavBar />

      {/* Hero banner */}
      <div style={heroBanner}>
        <div style={{ position: 'relative', zIndex: 1 }}>
          <h1 style={{ fontFamily: 'Playfair Display, serif', fontSize: 'clamp(1.75rem, 4vw, 2.75rem)', fontWeight: 700, color: 'white', margin: '0 0 0.5rem', textShadow: '0 2px 12px rgba(0,0,0,0.2)' }}>
            Khám phá Mùi Hương
          </h1>
          <p style={{ color: 'rgba(255,255,255,0.85)', fontSize: 16, margin: 0 }}>
            Hơn {MOCK_PRODUCTS.length * 10}+ sản phẩm nước hoa chính hãng
          </p>
        </div>
      </div>

      <main style={{ maxWidth: 1100, margin: '0 auto', padding: '2rem 1rem 4rem' }}>
        {/* ── Search & Filter bar ── */}
        <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap', marginBottom: '1.5rem', alignItems: 'center' }}>
          {/* Search */}
          <div style={{ flex: 1, minWidth: 220, display: 'flex', alignItems: 'center', background: 'white', border: '1.5px solid #e5e7eb', borderRadius: 12, padding: '0 14px', gap: 8, boxShadow: '0 2px 8px rgba(0,0,0,0.04)' }}>
            <Search size={16} style={{ color: '#9ca3af', flexShrink: 0 }} />
            <input
              value={search}
              onChange={e => { setSearch(e.target.value); setPage(1) }}
              placeholder="Tìm kiếm mùi hương..."
              style={{ border: 'none', outline: 'none', background: 'transparent', fontSize: 14, width: '100%', padding: '0.7rem 0', fontFamily: 'inherit', color: '#111827' }}
            />
            {search && (
              <button onClick={() => setSearch('')} style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9ca3af', padding: 0, minHeight: 'unset' }}>
                <X size={14} />
              </button>
            )}
          </div>

          {/* Sort */}
          <select
            value={sort}
            onChange={e => { setSort(e.target.value); setPage(1) }}
            style={selectStyle}
          >
            {SORTS.map(s => <option key={s.value} value={s.value}>{s.label}</option>)}
          </select>

          {/* Filter toggle */}
          <button onClick={() => setShowFilter(v => !v)} style={{ ...filterToggleBtn, borderColor: showFilter ? '#7c3aed' : '#e5e7eb', background: showFilter ? '#f3e8ff' : 'white', color: showFilter ? '#7c3aed' : '#374151' }}>
            <SlidersHorizontal size={15} /> Bộ lọc
          </button>
        </div>

        {/* ── Category tabs ── */}
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: '1.75rem' }}>
          {CATEGORIES.map(cat => (
            <button
              key={cat.id}
              onClick={() => { setCatId(cat.id); setPage(1) }}
              style={{
                padding: '0.4rem 1.1rem', borderRadius: 50, border: '1.5px solid',
                cursor: 'pointer', fontSize: 13, fontWeight: 500, fontFamily: 'inherit',
                background: catId === cat.id ? 'linear-gradient(135deg,#7c3aed,#a855f7)' : 'white',
                color: catId === cat.id ? 'white' : '#374151',
                borderColor: catId === cat.id ? 'transparent' : '#e5e7eb',
                boxShadow: catId === cat.id ? '0 2px 8px rgba(124,58,237,0.3)' : 'none',
                transition: 'all 0.2s', minHeight: 'unset',
              }}
            >
              {cat.label}
            </button>
          ))}
        </div>

        {/* Count */}
        <p style={{ fontSize: 14, color: '#6b7280', marginBottom: '1.25rem' }}>
          Tìm thấy <strong style={{ color: '#111827' }}>{products.length}</strong> sản phẩm
          {search && <> cho "<strong style={{ color: '#7c3aed' }}>{search}</strong>"</>}
        </p>

        {/* ── Grid ── */}
        {loading ? (
          <div style={{ display: 'flex', justifyContent: 'center', padding: '4rem' }}>
            <Loader2 size={36} style={{ color: '#7c3aed', animation: 'spin 1s linear infinite' }} />
          </div>
        ) : products.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '4rem', background: 'white', borderRadius: 20, border: '1px solid #f3e8ff' }}>
            <Search size={48} style={{ color: '#d8b4fe', margin: '0 auto 1rem' }} />
            <p style={{ fontWeight: 600, color: '#374151', fontSize: 16 }}>Không tìm thấy sản phẩm</p>
            <p style={{ color: '#9ca3af', fontSize: 14 }}>Hãy thử từ khóa khác</p>
          </div>
        ) : (
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))', gap: 20 }}>
            {products.map(p => <ProductCard key={p.id} product={p} />)}
          </div>
        )}

        {/* ── Pagination ── */}
        {totalPages > 1 && (
          <div style={{ display: 'flex', justifyContent: 'center', gap: 8, marginTop: '2.5rem' }}>
            {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
              <button
                key={p}
                onClick={() => setPage(p)}
                style={{
                  width: 38, height: 38, borderRadius: 10, border: '1.5px solid',
                  cursor: 'pointer', fontWeight: 600, fontSize: 14, fontFamily: 'inherit',
                  background: page === p ? 'linear-gradient(135deg,#7c3aed,#a855f7)' : 'white',
                  color: page === p ? 'white' : '#374151',
                  borderColor: page === p ? 'transparent' : '#e5e7eb',
                  minHeight: 'unset', transition: 'all 0.2s',
                }}
              >
                {p}
              </button>
            ))}
          </div>
        )}

        {/* View all CTA for demo */}
        {totalPages <= 1 && products.length > 0 && (
          <div style={{ textAlign: 'center', marginTop: '2.5rem' }}>
            <button
              style={{
                padding: '0.75rem 2.5rem', border: '1.5px solid #7c3aed', borderRadius: 50,
                background: 'transparent', color: '#7c3aed', fontWeight: 600, fontSize: 15,
                cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset',
                transition: 'all 0.2s',
              }}
            >
              Xem tất cả sản phẩm
            </button>
          </div>
        )}
      </main>

      <Footer />
      <style>{`
        @keyframes spin { to { transform: rotate(360deg); } }
        @media (max-width: 640px) {
          .products-grid { grid-template-columns: repeat(2, 1fr) !important; }
        }
      `}</style>
    </div>
  )
}

const heroBanner: React.CSSProperties = {
  background: 'linear-gradient(135deg, #4c1d95 0%, #7c3aed 40%, #a855f7 70%, #f0abfc 100%)',
  padding: '3.5rem 1rem',
  textAlign: 'center',
  position: 'relative',
  overflow: 'hidden',
}
const cardWrapper: React.CSSProperties = {
  background: 'white', borderRadius: 18, overflow: 'hidden',
  boxShadow: '0 2px 12px rgba(0,0,0,0.06)', border: '1px solid #f3e8ff',
  position: 'relative', transition: 'transform 0.2s, box-shadow 0.2s',
}
const imgBox: React.CSSProperties = {
  aspectRatio: '1', overflow: 'hidden', background: '#f3e8ff',
  position: 'relative',
}
const imgStyle: React.CSSProperties = {
  width: '100%', height: '100%', objectFit: 'cover',
  transition: 'transform 0.3s',
}
const discountTag: React.CSSProperties = {
  position: 'absolute', top: 10, left: 10,
  background: '#ef4444', color: 'white', fontSize: 11, fontWeight: 700,
  borderRadius: 6, padding: '0.2rem 0.5rem',
}
const wishBtn: React.CSSProperties = {
  position: 'absolute', top: 10, right: 10,
  width: 32, height: 32, borderRadius: '50%', border: '1.5px solid',
  display: 'flex', alignItems: 'center', justifyContent: 'center',
  cursor: 'pointer', minHeight: 'unset', transition: 'all 0.15s',
  boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
}
const selectStyle: React.CSSProperties = {
  padding: '0.625rem 0.875rem', border: '1.5px solid #e5e7eb',
  borderRadius: 12, fontSize: 14, fontFamily: 'inherit',
  outline: 'none', cursor: 'pointer', color: '#374151', background: 'white',
  boxShadow: '0 2px 8px rgba(0,0,0,0.04)',
}
const filterToggleBtn: React.CSSProperties = {
  display: 'inline-flex', alignItems: 'center', gap: 6,
  padding: '0.625rem 1rem', border: '1.5px solid', borderRadius: 12,
  fontSize: 14, fontWeight: 500, cursor: 'pointer', fontFamily: 'inherit',
  minHeight: 'unset', transition: 'all 0.2s',
}
