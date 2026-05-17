import React, { useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Menu, User, LogOut, ShoppingCart, Heart } from 'lucide-react'
import { Button } from '../components/ui/button'
import { useAuth } from '../contexts/AuthContext'

export default function NavBar() {
  const [open, setOpen] = useState(false)
  const { state, logout } = useAuth()
  const { user, isAuthenticated } = state
  const location = useLocation()
  const isHome = location.pathname === '/'

  const initials = user?.fullName
    ? user.fullName.split(' ').map((w: string) => w[0]).slice(-2).join('').toUpperCase()
    : (user?.email?.[0] ?? 'U').toUpperCase()

  return (
    <header style={{ width: '100%', background: 'white', boxShadow: '0 1px 8px rgba(0,0,0,0.06)', position: 'sticky', top: 0, zIndex: 50 }}>
      <div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between">

        {/* Logo */}
        <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: 10, textDecoration: 'none', minHeight: 'unset' }}>
          <div style={{ width: 38, height: 38, borderRadius: 10, background: 'linear-gradient(135deg,#7c3aed,#a855f7)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'white', fontWeight: 800, fontSize: 14, boxShadow: '0 4px 10px rgba(124,58,237,0.35)' }}>
            AH
          </div>
          <span style={{ fontSize: 17, fontWeight: 700, fontFamily: 'Playfair Display, serif', background: 'linear-gradient(135deg,#7c3aed,#a855f7)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text' }}>
            ScentVibe
          </span>
        </Link>

        {/* Desktop nav */}
        <nav className="hidden md:flex items-center gap-6" style={{ fontSize: 14, fontWeight: 500 }}>
          {isHome && (
            <>
              <a href="#services" style={navLink}>Dịch vụ</a>
              <a href="#pricing" style={navLink}>Bảng giá</a>
              <a href="#testimonials" style={navLink}>Đánh giá</a>
              <a href="#contact" style={navLink}>Liên hệ</a>
            </>
          )}
          <Link to="/products" style={{ ...navLink, color: location.pathname.startsWith('/products') ? '#7c3aed' : '#374151', fontWeight: location.pathname.startsWith('/products') ? 700 : 500 }}>
            Sản phẩm
          </Link>
        </nav>

        {/* Right area */}
        <div className="hidden md:flex items-center gap-2">
          {/* Cart */}
          <Link to="/cart" style={{ position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center', width: 38, height: 38, borderRadius: 10, background: '#f3e8ff', textDecoration: 'none', minHeight: 'unset' }}>
            <ShoppingCart size={17} style={{ color: '#7c3aed' }} />
          </Link>

          {/* Wishlist */}
          <Link to="/profile" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', width: 38, height: 38, borderRadius: 10, background: '#fdf2f8', textDecoration: 'none', minHeight: 'unset' }}>
            <Heart size={17} style={{ color: '#ec4899' }} />
          </Link>

          {/* Auth */}
          {isAuthenticated ? (
            <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <Link to="/profile" style={{ display: 'flex', alignItems: 'center', gap: 8, textDecoration: 'none', minHeight: 'unset', background: '#f3e8ff', borderRadius: 50, padding: '4px 12px 4px 4px' }}>
                <div style={{ width: 30, height: 30, borderRadius: '50%', background: 'linear-gradient(135deg,#7c3aed,#a855f7)', color: 'white', display: 'flex', alignItems: 'center', justifyContent: 'center', fontWeight: 700, fontSize: 12 }}>
                  {initials}
                </div>
                <span style={{ fontSize: 13, fontWeight: 600, color: '#7c3aed' }}>{user?.fullName?.split(' ').pop() ?? 'Tôi'}</span>
              </Link>
              <button
                onClick={logout}
                title="Đăng xuất"
                style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9ca3af', display: 'flex', alignItems: 'center', padding: 4, minHeight: 'unset', borderRadius: 8 }}
              >
                <LogOut size={16} />
              </button>
            </div>
          ) : (
            <Link to="/login">
              <Button
                id="navbar-login-btn"
                style={{ background: 'linear-gradient(135deg,#7c3aed,#a855f7)', color: 'white', border: 'none', borderRadius: 10, padding: '0 1.25rem', fontWeight: 600, fontSize: 14, boxShadow: '0 4px 12px rgba(124,58,237,0.3)', minHeight: 'unset', height: 38 }}
              >
                Đăng nhập
              </Button>
            </Link>
          )}
        </div>

        {/* Mobile hamburger */}
        <div className="md:hidden">
          <Button variant="ghost" aria-label="menu" onClick={() => setOpen(!open)} className="h-10 w-10 p-0">
            <Menu />
          </Button>
        </div>
      </div>

      {/* Mobile menu */}
      {open && (
        <div style={{ borderTop: '1px solid #f3e8ff', padding: '0.75rem 1rem', display: 'flex', flexDirection: 'column', gap: 4 }}>
          {isHome && <>
            <a href="#services" style={mobileLink}>Dịch vụ</a>
            <a href="#pricing" style={mobileLink}>Bảng giá</a>
            <a href="#testimonials" style={mobileLink}>Đánh giá</a>
            <a href="#contact" style={mobileLink}>Liên hệ</a>
          </>}
          <Link to="/products" style={mobileLink} onClick={() => setOpen(false)}>Sản phẩm</Link>
          <Link to="/cart" style={mobileLink} onClick={() => setOpen(false)}>Giỏ hàng</Link>
          {isAuthenticated ? (
            <>
              <Link to="/profile" style={mobileLink} onClick={() => setOpen(false)}>
                <User size={15} /> Tài khoản
              </Link>
              <button onClick={() => { logout(); setOpen(false) }} style={{ ...mobileLink, color: '#ef4444', background: 'none', border: 'none', cursor: 'pointer', textAlign: 'left' }}>
                <LogOut size={15} /> Đăng xuất
              </button>
            </>
          ) : (
            <Link to="/login" style={{ ...mobileLink, color: '#7c3aed', fontWeight: 600 }} onClick={() => setOpen(false)}>
              Đăng nhập
            </Link>
          )}
        </div>
      )}
    </header>
  )
}

const navLink: React.CSSProperties = {
  color: '#374151', textDecoration: 'none', minHeight: 'unset', transition: 'color 0.15s',
}
const mobileLink: React.CSSProperties = {
  display: 'flex', alignItems: 'center', gap: 8,
  padding: '0.625rem 0.5rem', color: '#374151', textDecoration: 'none',
  fontSize: 14, fontWeight: 500, borderRadius: 8, minHeight: 'unset',
}
