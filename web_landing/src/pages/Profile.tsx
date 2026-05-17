import React, { useState, useEffect } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {
  User, Heart, MapPin, Settings, LogOut,
  ShoppingBag, ChevronRight, Loader2, Package
} from 'lucide-react'
import NavBar from '../shared/NavBar'
import Footer from '../shared/Footer'
import { orderApi } from '../lib/shopApi'
import type { Order } from '../types/product.types'
import { useAuth } from '../contexts/AuthContext'

const fmt = (n: number) => n.toLocaleString('vi-VN') + 'đ'

type Tab = 'ALL' | 'PROCESSING' | 'SHIPPING' | 'COMPLETED' | 'CANCELLED'

const STATUS_MAP: Record<Order['status'], { label: string; color: string; bg: string }> = {
  PENDING:    { label: 'Chờ xác nhận', color: '#d97706', bg: '#fef3c7' },
  PROCESSING: { label: 'Đang xử lý',   color: '#d97706', bg: '#fef3c7' },
  SHIPPING:   { label: 'Đang giao',     color: '#2563eb', bg: '#dbeafe' },
  COMPLETED:  { label: 'Đã hoàn thành',color: '#059669', bg: '#d1fae5' },
  CANCELLED:  { label: 'Đã hủy',        color: '#dc2626', bg: '#fee2e2' },
}

const MOCK_ORDERS: Order[] = [
  {
    id: 'SV-98234', status: 'PROCESSING', totalAmount: 3450000,
    items: [
      { id: 'i1', productName: 'Midnight Lavender', productImage: 'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=100&q=80', quantity: 1, size: '50ml', unitPrice: 2450000 },
      { id: 'i2', productName: 'Urban Oasis', productImage: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=100&q=80', quantity: 1, size: '100ml', unitPrice: 1000000 },
    ],
    address: { id: 'a1', fullName: 'Nguyễn Văn A', phone: '0901234567', addressLine: '123 Lê Lợi', ward: 'Bến Thành', district: 'Quận 1', city: 'TP.HCM', isDefault: true },
    paymentMethod: 'COD',
    createdAt: '2024-05-24T08:00:00Z',
  },
  {
    id: 'SV-98122', status: 'COMPLETED', totalAmount: 1890000,
    items: [
      { id: 'i3', productName: 'Velvet Oud', productImage: 'https://images.unsplash.com/photo-1541643600914-78b084683702?w=100&q=80', quantity: 1, size: '30ml', unitPrice: 1890000 },
    ],
    address: { id: 'a1', fullName: 'Nguyễn Văn A', phone: '0901234567', addressLine: '123 Lê Lợi', ward: 'Bến Thành', district: 'Quận 1', city: 'TP.HCM', isDefault: true },
    paymentMethod: 'BANK_TRANSFER',
    createdAt: '2024-05-12T10:00:00Z',
  },
  {
    id: 'SV-97550', status: 'CANCELLED', totalAmount: 2100000,
    items: [
      { id: 'i4', productName: 'Neon Horizon', productImage: 'https://images.unsplash.com/photo-1615634260167-c8cdede054de?w=100&q=80', quantity: 1, size: '100ml', unitPrice: 2100000 },
    ],
    address: { id: 'a1', fullName: 'Nguyễn Văn A', phone: '0901234567', addressLine: '123 Lê Lợi', ward: 'Bến Thành', district: 'Quận 1', city: 'TP.HCM', isDefault: true },
    paymentMethod: 'COD',
    createdAt: '2024-05-02T10:00:00Z',
  },
]

const TABS: { key: Tab; label: string }[] = [
  { key: 'ALL', label: 'Tất cả' },
  { key: 'PROCESSING', label: 'Đang xử lý' },
  { key: 'SHIPPING', label: 'Đang giao' },
  { key: 'COMPLETED', label: 'Đã hoàn thành' },
  { key: 'CANCELLED', label: 'Đã hủy' },
]

type SideMenu = 'orders' | 'wishlist' | 'address' | 'settings'

export default function Profile() {
  const navigate = useNavigate()
  const { state, logout } = useAuth()
  const { user, isAuthenticated } = state

  const [activeMenu, setActiveMenu] = useState<SideMenu>('orders')
  const [activeTab, setActiveTab]   = useState<Tab>('ALL')
  const [orders, setOrders]         = useState<Order[]>(MOCK_ORDERS)
  const [loading, setLoading]       = useState(false)

  useEffect(() => {
    if (!isAuthenticated) { navigate('/login'); return }
    setLoading(true)
    orderApi.list()
      .then(r => setOrders(r.data))
      .catch(() => {})
      .finally(() => setLoading(false))
  }, [isAuthenticated, navigate])

  const filtered = activeTab === 'ALL'
    ? orders
    : orders.filter(o => {
        if (activeTab === 'PROCESSING') return o.status === 'PENDING' || o.status === 'PROCESSING'
        return o.status === activeTab
      })

  const initials = user?.fullName
    ? user.fullName.split(' ').map(w => w[0]).slice(-2).join('').toUpperCase()
    : (user?.email?.[0] ?? 'U').toUpperCase()

  const menuItems: { key: SideMenu; icon: React.ReactNode; label: string; danger?: boolean }[] = [
    { key: 'orders',    icon: <ShoppingBag size={18} />,  label: 'Đơn hàng của tôi' },
    { key: 'wishlist',  icon: <Heart size={18} />,         label: 'Yêu thích' },
    { key: 'address',   icon: <MapPin size={18} />,        label: 'Địa chỉ' },
    { key: 'settings',  icon: <Settings size={18} />,      label: 'Cài đặt' },
  ]

  return (
    <div style={{ minHeight: '100vh', background: '#faf5ff', fontFamily: 'Inter, sans-serif' }}>
      <NavBar />

      <main style={{ maxWidth: 1000, margin: '0 auto', padding: '2rem 1rem 4rem' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '240px 1fr', gap: '1.5rem', alignItems: 'start' }}>

          {/* ── Sidebar ── */}
          <div style={sidebar}>
            {/* Avatar */}
            <div style={{ textAlign: 'center', padding: '1.5rem 1rem 1.25rem', borderBottom: '1px solid #f3e8ff' }}>
              <div style={avatarCircle}>{initials}</div>
              <p style={{ fontWeight: 700, fontSize: 16, color: '#111827', margin: '0.75rem 0 0.25rem' }}>
                {user?.fullName ?? 'Người dùng'}
              </p>
              <p style={{ fontSize: 13, color: '#9ca3af', margin: 0 }}>{user?.email}</p>
            </div>

            {/* Menu */}
            <nav style={{ padding: '0.75rem' }}>
              {menuItems.map(m => (
                <button
                  key={m.key}
                  onClick={() => setActiveMenu(m.key)}
                  style={{
                    ...menuItem,
                    background: activeMenu === m.key ? 'linear-gradient(135deg,#7c3aed,#a855f7)' : 'transparent',
                    color: activeMenu === m.key ? 'white' : '#374151',
                  }}
                >
                  <span style={{ opacity: activeMenu === m.key ? 1 : 0.7 }}>{m.icon}</span>
                  {m.label}
                </button>
              ))}

              <button
                onClick={() => { logout(); navigate('/') }}
                style={{ ...menuItem, color: '#ef4444', marginTop: '0.5rem' }}
              >
                <LogOut size={18} style={{ opacity: 0.8 }} />
                Đăng xuất
              </button>
            </nav>
          </div>

          {/* ── Main Content ── */}
          <div>
            {activeMenu === 'orders' && (
              <>
                <h1 style={{ fontFamily: 'Playfair Display, serif', fontSize: '1.6rem', fontWeight: 700, color: '#0B1220', margin: '0 0 1.25rem' }}>
                  Đơn hàng của tôi
                </h1>

                {/* Tabs */}
                <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: '1.25rem' }}>
                  {TABS.map(t => (
                    <button
                      key={t.key}
                      onClick={() => setActiveTab(t.key)}
                      style={{
                        ...tabBtn,
                        background: activeTab === t.key ? 'linear-gradient(135deg,#7c3aed,#a855f7)' : 'white',
                        color: activeTab === t.key ? 'white' : '#374151',
                        borderColor: activeTab === t.key ? 'transparent' : '#e5e7eb',
                        boxShadow: activeTab === t.key ? '0 2px 8px rgba(124,58,237,0.3)' : 'none',
                      }}
                    >
                      {t.label}
                    </button>
                  ))}
                </div>

                {loading ? (
                  <div style={{ display: 'flex', justifyContent: 'center', padding: '3rem' }}>
                    <Loader2 size={32} style={{ color: '#7c3aed', animation: 'spin 1s linear infinite' }} />
                  </div>
                ) : filtered.length === 0 ? (
                  <div style={{ textAlign: 'center', padding: '3rem', background: 'white', borderRadius: 20 }}>
                    <Package size={48} style={{ color: '#d8b4fe', margin: '0 auto 1rem' }} />
                    <p style={{ fontWeight: 600, color: '#374151' }}>Không có đơn hàng nào</p>
                  </div>
                ) : (
                  <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
                    {filtered.map(order => {
                      const st = STATUS_MAP[order.status]
                      const extra = order.items.length - 2
                      return (
                        <div key={order.id} style={orderCard}>
                          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '0.875rem' }}>
                            <div>
                              <p style={{ fontWeight: 700, fontSize: 15, color: '#111827', margin: '0 0 3px' }}>Mã đơn hàng #{order.id}</p>
                              <p style={{ fontSize: 13, color: '#9ca3af', margin: 0 }}>
                                Đặt ngày {new Date(order.createdAt).toLocaleDateString('vi-VN', { day: 'numeric', month: 'long', year: 'numeric' })}
                              </p>
                            </div>
                            <span style={{ ...statusBadge, color: st.color, background: st.bg }}>
                              {st.label}
                            </span>
                          </div>

                          {/* Product images */}
                          <div style={{ display: 'flex', gap: 8, marginBottom: '0.875rem', alignItems: 'center' }}>
                            {order.items.slice(0, 2).map(item => (
                              <img key={item.id} src={item.productImage} alt={item.productName}
                                style={{ width: 56, height: 56, objectFit: 'cover', borderRadius: 10, background: '#f3e8ff' }} />
                            ))}
                            {extra > 0 && (
                              <div style={{ width: 56, height: 56, borderRadius: 10, background: '#f3e8ff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 700, fontSize: 14, color: '#7c3aed' }}>
                                +{extra}
                              </div>
                            )}
                          </div>

                          <div style={{ display: 'flex', justifyContent: 'flex-end', alignItems: 'center', gap: 12 }}>
                            <div style={{ textAlign: 'right' }}>
                              <p style={{ fontSize: 12, color: '#9ca3af', margin: '0 0 2px' }}>Tổng thanh toán</p>
                              <p style={{ fontWeight: 800, fontSize: 16, background: 'linear-gradient(135deg,#7c3aed,#a855f7)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text', margin: 0 }}>
                                {fmt(order.totalAmount)}
                              </p>
                            </div>
                            <Link
                              to={`/orders/${order.id}`}
                              style={{ display: 'inline-flex', alignItems: 'center', gap: 4, fontSize: 13, color: '#7c3aed', fontWeight: 600, textDecoration: 'none' }}
                            >
                              Xem chi tiết <ChevronRight size={14} />
                            </Link>
                          </div>
                        </div>
                      )
                    })}
                  </div>
                )}
              </>
            )}

            {activeMenu === 'wishlist' && (
              <EmptySection icon={<Heart size={48} style={{ color: '#d8b4fe' }} />} title="Danh sách yêu thích" desc="Chưa có sản phẩm yêu thích nào" />
            )}
            {activeMenu === 'address' && (
              <EmptySection icon={<MapPin size={48} style={{ color: '#d8b4fe' }} />} title="Địa chỉ của tôi" desc="Chưa có địa chỉ nào được lưu" />
            )}
            {activeMenu === 'settings' && (
              <div style={{ background: 'white', borderRadius: 20, padding: '2rem', border: '1px solid #f3e8ff' }}>
                <h2 style={{ fontFamily: 'Playfair Display, serif', fontSize: '1.4rem', fontWeight: 700, color: '#111827', margin: '0 0 1.5rem' }}>Cài đặt tài khoản</h2>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                  {[
                    { label: 'Họ và tên', value: user?.fullName ?? '—' },
                    { label: 'Email', value: user?.email ?? '—' },
                    { label: 'Số điện thoại', value: user?.phone ?? '—' },
                    { label: 'Hạng thành viên', value: user?.rank ?? 'Bạc' },
                    { label: 'Điểm tích lũy', value: `${user?.points ?? 0} điểm` },
                  ].map(f => (
                    <div key={f.label} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '0.75rem 0', borderBottom: '1px solid #f3f4f6' }}>
                      <span style={{ fontSize: 14, color: '#6b7280' }}>{f.label}</span>
                      <span style={{ fontSize: 14, fontWeight: 600, color: '#111827' }}>{f.value}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </main>

      <Footer />
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  )
}

function EmptySection({ icon, title, desc }: { icon: React.ReactNode; title: string; desc: string }) {
  return (
    <div>
      <h1 style={{ fontFamily: 'Playfair Display, serif', fontSize: '1.6rem', fontWeight: 700, color: '#0B1220', margin: '0 0 1.25rem' }}>{title}</h1>
      <div style={{ textAlign: 'center', padding: '4rem 1rem', background: 'white', borderRadius: 20, border: '1px solid #f3e8ff' }}>
        <div style={{ margin: '0 auto 1rem' }}>{icon}</div>
        <p style={{ fontSize: 15, color: '#374151', fontWeight: 500 }}>{desc}</p>
      </div>
    </div>
  )
}

const sidebar: React.CSSProperties = {
  background: 'white', borderRadius: 20, border: '1px solid #f3e8ff',
  boxShadow: '0 4px 20px rgba(124,58,237,0.06)', overflow: 'hidden',
  position: 'sticky', top: 100,
}
const avatarCircle: React.CSSProperties = {
  width: 68, height: 68, borderRadius: '50%',
  background: 'linear-gradient(135deg,#7c3aed,#a855f7)', color: 'white',
  display: 'flex', alignItems: 'center', justifyContent: 'center',
  fontWeight: 800, fontSize: 22, margin: '0 auto',
  boxShadow: '0 4px 16px rgba(124,58,237,0.4)',
}
const menuItem: React.CSSProperties = {
  width: '100%', display: 'flex', alignItems: 'center', gap: 10,
  padding: '0.7rem 1rem', borderRadius: 12, border: 'none', cursor: 'pointer',
  fontFamily: 'inherit', fontSize: 14, fontWeight: 500, marginBottom: 2,
  transition: 'all 0.2s', textAlign: 'left', minHeight: 'unset',
}
const tabBtn: React.CSSProperties = {
  padding: '0.4rem 1rem', border: '1.5px solid', borderRadius: 50,
  cursor: 'pointer', fontFamily: 'inherit', fontSize: 13, fontWeight: 500,
  transition: 'all 0.2s', minHeight: 'unset',
}
const orderCard: React.CSSProperties = {
  background: 'white', borderRadius: 16, padding: '1.25rem',
  border: '1px solid #f3e8ff', boxShadow: '0 2px 8px rgba(0,0,0,0.04)',
}
const statusBadge: React.CSSProperties = {
  fontSize: 12, fontWeight: 600, borderRadius: 20, padding: '0.3rem 0.75rem', flexShrink: 0,
}
