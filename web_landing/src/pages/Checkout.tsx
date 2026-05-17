import React, { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import {
  CheckCircle2, ChevronRight, MapPin, Plus, Truck, Loader2,
  Landmark, CreditCard
} from 'lucide-react'
import NavBar from '../shared/NavBar'
import Footer from '../shared/Footer'
import { addressApi, orderApi, cartApi } from '../lib/shopApi'
import type { Address, Cart } from '../types/product.types'
import { useAuth } from '../contexts/AuthContext'

const fmt = (n: number) => n.toLocaleString('vi-VN') + 'đ'

type Step = 1 | 2 | 3

// Mock data
const MOCK_ADDRESSES: Address[] = [
  { id: '1', fullName: 'Trần Hoàng Nam', phone: '0912 345 678', addressLine: 'Số 123, Đường Lê Lợi', ward: 'Phường Bến Thành', district: 'Quận 1', city: 'TP. Hồ Chí Minh', isDefault: true },
  { id: '2', fullName: 'Hoàng Anh', phone: '0988 777 666', addressLine: '25/10 Xuân Thủy', ward: 'Dịch Vọng Hậu', district: 'Cầu Giấy', city: 'Hà Nội', isDefault: false },
]
const MOCK_CART: Cart = {
  items: [
    { id: '1', product: { id: 'p1', name: 'Midnight Bloom', brand: '', description: '', price: 1250000, discountPercent: 0, imageUrl: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=100&q=80', images: [], averageRating: 0, totalReviews: 0, category: { id: '1', name: '', slug: '' }, sizes: ['50ml'], type: '', createdAt: '' }, quantity: 1, size: '50ml', unitPrice: 1250000 },
    { id: '2', product: { id: 'p2', name: 'Urban Citrus', brand: '', description: '', price: 350000, discountPercent: 0, imageUrl: 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?w=100&q=80', images: [], averageRating: 0, totalReviews: 0, category: { id: '2', name: '', slug: '' }, sizes: ['10ml'], type: '', createdAt: '' }, quantity: 1, size: '10ml', unitPrice: 350000 },
  ],
  total: 1600000,
}

export default function Checkout() {
  const navigate = useNavigate()
  const { state: authState } = useAuth()

  const [step, setStep]               = useState<Step>(1)
  const [addresses, setAddresses]     = useState<Address[]>(MOCK_ADDRESSES)
  const [cart, setCart]               = useState<Cart>(MOCK_CART)
  const [selectedAddr, setSelectedAddr] = useState('1')
  const [payment, setPayment]         = useState<'COD' | 'BANK_TRANSFER'>('COD')
  const [note, setNote]               = useState('')
  const [fullName, setFullName]       = useState('')
  const [phone, setPhone]             = useState('')
  const [loading, setLoading]         = useState(false)
  const [placing, setPlacing]         = useState(false)
  const [orderId, setOrderId]         = useState<string | null>(null)

  useEffect(() => {
    if (!authState.isAuthenticated) { navigate('/login'); return }
    setLoading(true)
    Promise.all([addressApi.list(), cartApi.get()])
      .then(([a, c]) => { setAddresses(a.data); setCart(c.data); if (a.data[0]) setSelectedAddr(a.data[0].id) })
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [authState.isAuthenticated, navigate])

  const subtotal = cart.items.reduce((s, i) => s + i.unitPrice * i.quantity, 0)
  const shipping = 30000
  const voucher  = 50000
  const total    = subtotal + shipping - voucher

  async function handlePlace() {
    setPlacing(true)
    try {
      const res = await orderApi.create({ addressId: selectedAddr, paymentMethod: payment, note })
      setOrderId(res.data.id)
      setStep(3)
    } catch {
      // mock success for demo
      setOrderId('SV-' + Math.floor(Math.random() * 90000 + 10000))
      setStep(3)
    } finally {
      setPlacing(false)
    }
  }

  const activeAddr = addresses.find(a => a.id === selectedAddr) ?? addresses[0]

  if (loading) return (
    <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#faf5ff' }}>
      <Loader2 size={36} style={{ color: '#7c3aed', animation: 'spin 1s linear infinite' }} />
    </div>
  )

  return (
    <div style={{ minHeight: '100vh', background: '#faf5ff', fontFamily: 'Inter, sans-serif' }}>
      <NavBar />

      <main style={{ maxWidth: 820, margin: '0 auto', padding: '2rem 1rem 4rem' }}>

        {/* Step indicator */}
        <div style={stepRow}>
          {[{ n: 1, label: 'Địa chỉ' }, { n: 2, label: 'Xem lại' }, { n: 3, label: 'Thanh toán' }].map((s, i, arr) => (
            <React.Fragment key={s.n}>
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6 }}>
                <div style={{
                  ...stepCircle,
                  background: step >= s.n ? 'linear-gradient(135deg,#7c3aed,#a855f7)' : 'white',
                  color: step >= s.n ? 'white' : '#9ca3af',
                  border: step >= s.n ? 'none' : '2px solid #e5e7eb',
                }}>
                  {step > s.n ? <CheckCircle2 size={16} /> : s.n}
                </div>
                <span style={{ fontSize: 12, fontWeight: 500, color: step >= s.n ? '#7c3aed' : '#9ca3af' }}>{s.label}</span>
              </div>
              {i < arr.length - 1 && (
                <div style={{ flex: 1, height: 2, background: step > s.n ? 'linear-gradient(90deg,#7c3aed,#a855f7)' : '#e5e7eb', marginBottom: 20, transition: 'background 0.3s' }} />
              )}
            </React.Fragment>
          ))}
        </div>

        {/* ── Step 1: Address ── */}
        {step === 1 && (
          <div style={stepContent}>
            <section style={{ marginBottom: '2rem' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
                <h2 style={sectionTitle}><MapPin size={18} style={{ display: 'inline', marginRight: 6, color: '#7c3aed' }} />Địa chỉ nhận hàng</h2>
                <button style={ghostBtn}><Plus size={14} /> Thêm địa chỉ mới</button>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                {addresses.map(a => (
                  <button
                    key={a.id}
                    onClick={() => setSelectedAddr(a.id)}
                    style={{
                      ...addrCard,
                      borderColor: selectedAddr === a.id ? '#7c3aed' : '#e5e7eb',
                      boxShadow: selectedAddr === a.id ? '0 0 0 2px rgba(124,58,237,0.2)' : 'none',
                    }}
                  >
                    {selectedAddr === a.id && (
                      <div style={selectedDot}><CheckCircle2 size={16} /></div>
                    )}
                    {a.isDefault && <span style={defaultBadge}>Mặc định</span>}
                    <p style={{ fontWeight: 700, fontSize: 14, margin: '0 0 4px', color: '#111827' }}>{a.fullName}</p>
                    <p style={{ fontSize: 13, color: '#6b7280', margin: '0 0 4px' }}>{a.phone}</p>
                    <p style={{ fontSize: 13, color: '#374151', margin: 0, lineHeight: 1.5 }}>
                      {a.addressLine}, {a.ward}, {a.district}, {a.city}
                    </p>
                  </button>
                ))}
              </div>
            </section>

            {/* Contact */}
            <section style={{ background: 'white', borderRadius: 16, padding: '1.25rem', border: '1px solid #f3e8ff', marginBottom: '2rem' }}>
              <h2 style={{ ...sectionTitle, marginBottom: '1rem' }}>Thông tin liên lạc</h2>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, marginBottom: 12 }}>
                <div>
                  <label style={fieldLbl}>Họ và tên</label>
                  <input value={fullName} onChange={e => setFullName(e.target.value)} placeholder="Nhập tên của bạn" style={fieldInput} />
                </div>
                <div>
                  <label style={fieldLbl}>Số điện thoại</label>
                  <input value={phone} onChange={e => setPhone(e.target.value)} placeholder="0xxx xxx xxx" style={fieldInput} />
                </div>
              </div>
              <div>
                <label style={fieldLbl}>Ghi chú cho đơn hàng</label>
                <textarea value={note} onChange={e => setNote(e.target.value)} placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi đến..." rows={3} style={{ ...fieldInput, resize: 'none', height: 'auto' }} />
              </div>
            </section>

            {/* Payment */}
            <section>
              <h2 style={{ ...sectionTitle, marginBottom: '1rem' }}>Phương thức thanh toán</h2>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                {([
                  { value: 'COD' as const, icon: <Truck size={20} style={{ color: '#7c3aed' }} />, label: 'Thanh toán khi nhận hàng (COD)', sub: 'Thanh toán bằng tiền mặt khi shipper giao tới' },
                  { value: 'BANK_TRANSFER' as const, icon: <Landmark size={20} style={{ color: '#7c3aed' }} />, label: 'Chuyển khoản ngân hàng', sub: 'Nhanh chóng và an toàn qua VietQR' },
                ]).map(p => (
                  <button
                    key={p.value}
                    onClick={() => setPayment(p.value)}
                    style={{
                      ...payCard,
                      borderColor: payment === p.value ? '#7c3aed' : '#e5e7eb',
                      background: payment === p.value ? '#faf5ff' : 'white',
                      boxShadow: payment === p.value ? '0 0 0 2px rgba(124,58,237,0.2)' : 'none',
                    }}
                  >
                    {p.icon}
                    <div style={{ textAlign: 'left' }}>
                      <p style={{ fontWeight: 600, fontSize: 14, margin: '0 0 3px', color: '#111827' }}>{p.label}</p>
                      <p style={{ fontSize: 12, color: '#6b7280', margin: 0 }}>{p.sub}</p>
                    </div>
                  </button>
                ))}
              </div>
            </section>

            <button onClick={() => setStep(2)} style={{ ...primaryBtn, marginTop: '1.5rem', width: '100%' }}>
              Tiếp theo <ChevronRight size={16} />
            </button>
          </div>
        )}

        {/* ── Step 2: Review ── */}
        {step === 2 && (
          <div style={stepContent}>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 340px', gap: '1.5rem', alignItems: 'start' }}>
              <div>
                <h2 style={{ ...sectionTitle, marginBottom: '1rem' }}>Đơn hàng của bạn</h2>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                  {cart.items.map(item => (
                    <div key={item.id} style={{ background: 'white', borderRadius: 14, padding: '0.875rem 1rem', display: 'flex', gap: 12, border: '1px solid #f3e8ff' }}>
                      <img src={item.product.imageUrl} alt={item.product.name} style={{ width: 64, height: 64, objectFit: 'cover', borderRadius: 10, background: '#f3e8ff' }} />
                      <div style={{ flex: 1 }}>
                        <p style={{ fontWeight: 600, fontSize: 14, margin: '0 0 2px', color: '#111827' }}>{item.product.name}</p>
                        <p style={{ fontSize: 12, color: '#9ca3af', margin: '0 0 6px' }}>{item.size}</p>
                        <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                          <span style={{ fontSize: 13, color: '#6b7280' }}>x{item.quantity}</span>
                          <span style={{ fontWeight: 700, fontSize: 14, color: '#7c3aed' }}>{fmt(item.unitPrice * item.quantity)}</span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>

                <div style={{ background: 'white', borderRadius: 14, padding: '1rem', border: '1px solid #f3e8ff', marginTop: 12 }}>
                  <p style={{ fontSize: 12, fontWeight: 700, color: '#9ca3af', letterSpacing: '0.05em', margin: '0 0 8px' }}>ĐỊA CHỈ GIAO HÀNG</p>
                  <p style={{ fontSize: 14, fontWeight: 600, color: '#111827', margin: '0 0 2px' }}>{activeAddr?.fullName}</p>
                  <p style={{ fontSize: 13, color: '#6b7280', margin: '0 0 2px' }}>{activeAddr?.phone}</p>
                  <p style={{ fontSize: 13, color: '#374151', margin: 0, lineHeight: 1.5 }}>
                    {activeAddr?.addressLine}, {activeAddr?.ward}, {activeAddr?.district}, {activeAddr?.city}
                  </p>
                </div>
              </div>

              {/* Order summary */}
              <div style={summaryBox}>
                <h3 style={{ fontWeight: 700, fontSize: 16, margin: '0 0 1rem', color: '#111827' }}>Tóm tắt thanh toán</h3>
                {[
                  { label: 'Tạm tính', val: fmt(subtotal) },
                  { label: 'Phí vận chuyển', val: fmt(shipping) },
                  { label: 'Giảm giá voucher', val: `-${fmt(voucher)}`, red: true },
                ].map(r => (
                  <div key={r.label} style={{ display: 'flex', justifyContent: 'space-between', fontSize: 14, marginBottom: 8 }}>
                    <span style={{ color: '#6b7280' }}>{r.label}</span>
                    <span style={{ fontWeight: 600, color: r.red ? '#e11d48' : '#111827' }}>{r.val}</span>
                  </div>
                ))}
                <div style={{ borderTop: '1px dashed #e5e7eb', paddingTop: '1rem', display: 'flex', justifyContent: 'space-between', marginBottom: '1.25rem' }}>
                  <span style={{ fontWeight: 700, fontSize: 16 }}>Tổng cộng</span>
                  <span style={{ fontWeight: 800, fontSize: 20, background: 'linear-gradient(135deg,#7c3aed,#a855f7)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>{fmt(total)}</span>
                </div>

                <button id="place-order-btn" onClick={handlePlace} disabled={placing} style={primaryBtn}>
                  {placing ? <Loader2 size={16} style={{ animation: 'spin 1s linear infinite' }} /> : <CreditCard size={16} />}
                  ĐẶT HÀNG NGAY
                </button>
                <p style={{ fontSize: 11, color: '#9ca3af', textAlign: 'center', marginTop: 10, lineHeight: 1.5 }}>
                  Bằng cách nhấp vào "Đặt hàng ngay", bạn đồng ý với Điều khoản dịch vụ của ScentVibe.
                </p>
              </div>
            </div>

            <button onClick={() => setStep(1)} style={{ ...ghostBtn, marginTop: '1rem' }}>← Quay lại</button>
          </div>
        )}

        {/* ── Step 3: Success ── */}
        {step === 3 && (
          <div style={{ textAlign: 'center', padding: '3rem 1rem' }}>
            <div style={{ width: 80, height: 80, borderRadius: '50%', background: 'linear-gradient(135deg,#7c3aed,#a855f7)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 1.5rem', boxShadow: '0 8px 24px rgba(124,58,237,0.4)' }}>
              <CheckCircle2 size={40} color="white" />
            </div>
            <h2 style={{ fontFamily: 'Playfair Display, serif', fontSize: '1.75rem', fontWeight: 700, color: '#111827', margin: '0 0 0.5rem' }}>Đặt hàng thành công!</h2>
            <p style={{ color: '#6b7280', marginBottom: '0.25rem' }}>Mã đơn hàng của bạn:</p>
            <p style={{ fontSize: '1.25rem', fontWeight: 800, color: '#7c3aed', marginBottom: '1.5rem' }}>#{orderId}</p>
            <p style={{ color: '#374151', fontSize: 14, maxWidth: 360, margin: '0 auto 2rem', lineHeight: 1.6 }}>
              Chúng tôi sẽ gửi thông báo khi đơn hàng của bạn được xử lý. Cảm ơn bạn đã mua sắm tại ScentVibe!
            </p>
            <div style={{ display: 'flex', gap: 12, justifyContent: 'center', flexWrap: 'wrap' }}>
              <button onClick={() => navigate('/profile')} style={primaryBtn}>Xem đơn hàng</button>
              <button onClick={() => navigate('/')} style={{ ...primaryBtn, background: 'white', color: '#7c3aed', border: '1.5px solid #7c3aed', boxShadow: 'none' }}>Tiếp tục mua sắm</button>
            </div>
          </div>
        )}
      </main>

      <Footer />
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  )
}

const stepRow: React.CSSProperties = {
  display: 'flex', alignItems: 'flex-start', gap: 0, marginBottom: '2.5rem',
}
const stepCircle: React.CSSProperties = {
  width: 36, height: 36, borderRadius: '50%', display: 'flex',
  alignItems: 'center', justifyContent: 'center', fontWeight: 700, fontSize: 14, transition: 'all 0.3s',
}
const stepContent: React.CSSProperties = {}
const sectionTitle: React.CSSProperties = {
  fontWeight: 700, fontSize: 16, color: '#111827', margin: 0, display: 'flex', alignItems: 'center',
}
const addrCard: React.CSSProperties = {
  background: 'white', borderRadius: 14, padding: '1rem', border: '1.5px solid',
  cursor: 'pointer', textAlign: 'left', position: 'relative', transition: 'all 0.2s',
  fontFamily: 'inherit', minHeight: 'unset',
}
const selectedDot: React.CSSProperties = {
  position: 'absolute', top: 10, right: 10, color: '#7c3aed',
}
const defaultBadge: React.CSSProperties = {
  display: 'inline-block', fontSize: 11, fontWeight: 600, color: '#7c3aed',
  background: '#f3e8ff', borderRadius: 6, padding: '0.15rem 0.5rem', marginBottom: 6,
}
const payCard: React.CSSProperties = {
  display: 'flex', alignItems: 'flex-start', gap: 12, padding: '1rem',
  border: '1.5px solid', borderRadius: 14, cursor: 'pointer',
  textAlign: 'left', transition: 'all 0.2s', fontFamily: 'inherit', minHeight: 'unset',
}
const fieldLbl: React.CSSProperties = {
  display: 'block', fontSize: 12, fontWeight: 600, color: '#374151', marginBottom: 6,
}
const fieldInput: React.CSSProperties = {
  width: '100%', border: '1.5px solid #e5e7eb', borderRadius: 10,
  padding: '0.625rem 0.875rem', fontSize: 14, fontFamily: 'inherit',
  outline: 'none', color: '#111827', boxSizing: 'border-box',
  background: '#f9fafb', transition: 'border-color 0.2s',
}
const primaryBtn: React.CSSProperties = {
  display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
  background: 'linear-gradient(135deg,#7c3aed,#a855f7)', color: 'white',
  border: 'none', borderRadius: 14, padding: '0.875rem 2rem', fontWeight: 700,
  fontSize: 15, cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset',
  boxShadow: '0 4px 14px rgba(124,58,237,0.4)', transition: 'all 0.2s',
}
const ghostBtn: React.CSSProperties = {
  display: 'inline-flex', alignItems: 'center', gap: 6,
  background: 'none', border: '1px solid #e5e7eb', borderRadius: 10,
  padding: '0.5rem 1rem', fontSize: 14, fontWeight: 500, color: '#374151',
  cursor: 'pointer', fontFamily: 'inherit', minHeight: 'unset',
}
const summaryBox: React.CSSProperties = {
  background: 'white', borderRadius: 20, padding: '1.5rem',
  border: '1px solid #f3e8ff', boxShadow: '0 4px 20px rgba(124,58,237,0.08)',
  position: 'sticky', top: 100,
}
