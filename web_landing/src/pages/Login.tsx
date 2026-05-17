import React, { useState, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Eye, EyeOff, Mail, Lock, Loader2, Sparkles } from 'lucide-react'
import { useAuth } from '../contexts/AuthContext'

// ── Validation helpers ────────────────────────────────────────────────────────
function validateEmail(v: string) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) ? '' : 'Email không hợp lệ'
}
function validatePassword(v: string) {
  return v.length >= 6 ? '' : 'Mật khẩu tối thiểu 6 ký tự'
}

export default function Login() {
  const navigate = useNavigate()
  const { login } = useAuth()

  const [email, setEmail]           = useState('')
  const [password, setPassword]     = useState('')
  const [showPass, setShowPass]     = useState(false)
  const [emailErr, setEmailErr]     = useState('')
  const [passErr, setPassErr]       = useState('')
  const [apiError, setApiError]     = useState('')
  const [isLoading, setIsLoading]   = useState(false)

  function validate() {
    const eErr = validateEmail(email)
    const pErr = validatePassword(password)
    setEmailErr(eErr)
    setPassErr(pErr)
    return !eErr && !pErr
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setApiError('')
    if (!validate()) return

    setIsLoading(true)
    try {
      await login(email, password)
      navigate('/')
    } catch (err) {
      setApiError(err instanceof Error ? err.message : 'Đăng nhập thất bại')
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="login-page">
      {/* ── Background blobs ── */}
      <div className="blob blob-1" />
      <div className="blob blob-2" />
      <div className="blob blob-3" />

      {/* ── Card ── */}
      <div className="login-card">
        {/* Logo */}
        <div className="login-logo">
          <div className="logo-icon">
            <Sparkles size={22} strokeWidth={1.8} />
          </div>
          <span className="logo-text">ScentVibe</span>
        </div>

        <h1 className="login-title">Chào mừng trở lại</h1>
        <p className="login-subtitle">Đăng nhập để khám phá thế giới mùi hương</p>

        {/* ── Form ── */}
        <form onSubmit={handleSubmit} noValidate className="login-form">
          {/* Email */}
          <div className="field-group">
            <label htmlFor="login-email" className="field-label">Email</label>
            <div className={`input-wrapper ${emailErr ? 'input-error' : ''}`}>
              <Mail size={16} className="input-icon" />
              <input
                id="login-email"
                type="email"
                autoComplete="email"
                placeholder="example@email.com"
                value={email}
                onChange={e => { setEmail(e.target.value); setEmailErr('') }}
                className="field-input"
              />
            </div>
            {emailErr && <span className="field-error">{emailErr}</span>}
          </div>

          {/* Password */}
          <div className="field-group">
            <label htmlFor="login-password" className="field-label">Mật khẩu</label>
            <div className={`input-wrapper ${passErr ? 'input-error' : ''}`}>
              <Lock size={16} className="input-icon" />
              <input
                id="login-password"
                type={showPass ? 'text' : 'password'}
                autoComplete="current-password"
                placeholder="••••••••"
                value={password}
                onChange={e => { setPassword(e.target.value); setPassErr('') }}
                className="field-input"
              />
              <button
                type="button"
                onClick={() => setShowPass(v => !v)}
                className="pass-toggle"
                aria-label={showPass ? 'Ẩn mật khẩu' : 'Hiện mật khẩu'}
              >
                {showPass ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>
            {passErr && <span className="field-error">{passErr}</span>}
          </div>

          {/* Forgot */}
          <div className="forgot-row">
            <a href="#" className="forgot-link">Quên mật khẩu?</a>
          </div>

          {/* API error */}
          {apiError && (
            <div className="api-error" role="alert">
              {apiError}
            </div>
          )}

          {/* Submit */}
          <button
            id="login-submit"
            type="submit"
            disabled={isLoading}
            className="login-btn"
          >
            {isLoading ? (
              <>
                <Loader2 size={18} className="spin" />
                Đang đăng nhập…
              </>
            ) : (
              'Đăng nhập'
            )}
          </button>
        </form>

        {/* ── Divider ── */}
        <div className="divider">
          <span>hoặc</span>
        </div>

        {/* ── Google ── */}
        <button id="google-login-btn" type="button" className="google-btn">
          <svg width="18" height="18" viewBox="0 0 24 24" aria-hidden="true">
            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
          </svg>
          Tiếp tục với Google
        </button>

        {/* ── Register link ── */}
        <p className="register-link">
          Chưa có tài khoản?{' '}
          <Link to="/register">Đăng ký ngay</Link>
        </p>
      </div>

      {/* ── Inline styles ── */}
      <style>{`
        .login-page {
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          background: #f5f3ff;
          position: relative;
          overflow: hidden;
          padding: 1rem;
        }

        /* Blobs */
        .blob {
          position: absolute;
          border-radius: 50%;
          filter: blur(80px);
          opacity: 0.35;
          pointer-events: none;
        }
        .blob-1 {
          width: 520px; height: 520px;
          background: radial-gradient(circle, #c084fc, #818cf8);
          top: -160px; left: -120px;
          animation: float1 8s ease-in-out infinite;
        }
        .blob-2 {
          width: 400px; height: 400px;
          background: radial-gradient(circle, #f9a8d4, #c084fc);
          bottom: -120px; right: -80px;
          animation: float2 10s ease-in-out infinite;
        }
        .blob-3 {
          width: 280px; height: 280px;
          background: radial-gradient(circle, #a5b4fc, #60a5fa);
          top: 50%; left: 55%;
          animation: float1 12s ease-in-out infinite reverse;
        }
        @keyframes float1 {
          0%, 100% { transform: translateY(0) scale(1); }
          50%       { transform: translateY(-30px) scale(1.05); }
        }
        @keyframes float2 {
          0%, 100% { transform: translateY(0) scale(1); }
          50%       { transform: translateY(24px) scale(0.97); }
        }

        /* Card */
        .login-card {
          position: relative;
          z-index: 10;
          width: 100%;
          max-width: 420px;
          background: rgba(255, 255, 255, 0.78);
          backdrop-filter: blur(20px);
          -webkit-backdrop-filter: blur(20px);
          border: 1px solid rgba(255, 255, 255, 0.6);
          border-radius: 24px;
          padding: 2.5rem 2rem;
          box-shadow:
            0 8px 32px rgba(129, 140, 248, 0.15),
            0 2px 8px rgba(0,0,0,0.06);
          animation: slideUp 0.45s cubic-bezier(0.16,1,0.3,1) both;
        }
        @keyframes slideUp {
          from { opacity: 0; transform: translateY(32px); }
          to   { opacity: 1; transform: translateY(0); }
        }

        /* Logo */
        .login-logo {
          display: flex;
          align-items: center;
          gap: 0.625rem;
          margin-bottom: 1.75rem;
        }
        .logo-icon {
          width: 40px; height: 40px;
          background: linear-gradient(135deg, #7c3aed, #a855f7);
          border-radius: 10px;
          display: flex;
          align-items: center;
          justify-content: center;
          color: white;
          box-shadow: 0 4px 12px rgba(124, 58, 237, 0.35);
        }
        .logo-text {
          font-family: 'Playfair Display', serif;
          font-size: 1.35rem;
          font-weight: 700;
          background: linear-gradient(135deg, #7c3aed, #a855f7);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }

        /* Headings */
        .login-title {
          font-family: 'Playfair Display', serif;
          font-size: 1.6rem;
          font-weight: 700;
          color: #0B1220;
          margin: 0 0 0.4rem;
          line-height: 1.2;
        }
        .login-subtitle {
          font-size: 0.875rem;
          color: #6b7280;
          margin: 0 0 1.75rem;
        }

        /* Form */
        .login-form { display: flex; flex-direction: column; gap: 1rem; }

        .field-group { display: flex; flex-direction: column; gap: 0.35rem; }

        .field-label {
          font-size: 0.8125rem;
          font-weight: 600;
          color: #374151;
        }

        .input-wrapper {
          position: relative;
          display: flex;
          align-items: center;
          background: rgba(255,255,255,0.9);
          border: 1.5px solid #e5e7eb;
          border-radius: 12px;
          transition: border-color 0.2s, box-shadow 0.2s;
          overflow: hidden;
        }
        .input-wrapper:focus-within {
          border-color: #7c3aed;
          box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.12);
        }
        .input-wrapper.input-error {
          border-color: #f43f5e;
          box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.1);
        }

        .input-icon {
          position: absolute;
          left: 0.875rem;
          color: #9ca3af;
          pointer-events: none;
          flex-shrink: 0;
        }

        .field-input {
          width: 100%;
          padding: 0.75rem 0.875rem 0.75rem 2.6rem;
          background: transparent;
          border: none;
          outline: none;
          font-size: 0.9rem;
          color: #111827;
          font-family: 'Inter', sans-serif;
          min-height: unset;
        }
        .field-input::placeholder { color: #d1d5db; }

        .pass-toggle {
          position: absolute;
          right: 0.75rem;
          background: none;
          border: none;
          cursor: pointer;
          color: #9ca3af;
          display: flex;
          align-items: center;
          padding: 0;
          min-height: unset;
          transition: color 0.15s;
        }
        .pass-toggle:hover { color: #7c3aed; }

        .field-error {
          font-size: 0.775rem;
          color: #f43f5e;
        }

        /* Forgot */
        .forgot-row {
          display: flex;
          justify-content: flex-end;
          margin-top: -0.25rem;
        }
        .forgot-link {
          font-size: 0.8125rem;
          color: #7c3aed;
          text-decoration: none;
          font-weight: 500;
          min-height: unset;
          transition: opacity 0.15s;
        }
        .forgot-link:hover { opacity: 0.75; }

        /* API error */
        .api-error {
          background: #fff1f2;
          border: 1px solid #fecdd3;
          border-radius: 10px;
          padding: 0.625rem 0.875rem;
          font-size: 0.8125rem;
          color: #e11d48;
          text-align: center;
        }

        /* Submit button */
        .login-btn {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 0.5rem;
          width: 100%;
          padding: 0.8125rem;
          background: linear-gradient(135deg, #7c3aed, #a855f7);
          color: white;
          border: none;
          border-radius: 12px;
          font-size: 0.9375rem;
          font-weight: 600;
          font-family: 'Inter', sans-serif;
          cursor: pointer;
          min-height: unset;
          box-shadow: 0 4px 14px rgba(124, 58, 237, 0.4);
          transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
          margin-top: 0.25rem;
        }
        .login-btn:hover:not(:disabled) {
          opacity: 0.92;
          transform: translateY(-1px);
          box-shadow: 0 6px 20px rgba(124, 58, 237, 0.5);
        }
        .login-btn:active:not(:disabled) { transform: translateY(0); }
        .login-btn:disabled { opacity: 0.65; cursor: not-allowed; }

        .spin {
          animation: spin 0.75s linear infinite;
        }
        @keyframes spin {
          to { transform: rotate(360deg); }
        }

        /* Divider */
        .divider {
          display: flex;
          align-items: center;
          gap: 0.75rem;
          margin: 1.25rem 0;
          color: #9ca3af;
          font-size: 0.8125rem;
        }
        .divider::before,
        .divider::after {
          content: '';
          flex: 1;
          height: 1px;
          background: #e5e7eb;
        }

        /* Google button */
        .google-btn {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 0.625rem;
          width: 100%;
          padding: 0.75rem;
          background: white;
          border: 1.5px solid #e5e7eb;
          border-radius: 12px;
          font-size: 0.875rem;
          font-weight: 500;
          font-family: 'Inter', sans-serif;
          color: #374151;
          cursor: pointer;
          min-height: unset;
          transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
        }
        .google-btn:hover {
          border-color: #7c3aed;
          background: #faf5ff;
          box-shadow: 0 2px 8px rgba(124, 58, 237, 0.1);
        }

        /* Register link */
        .register-link {
          text-align: center;
          font-size: 0.8125rem;
          color: #6b7280;
          margin: 1.25rem 0 0;
        }
        .register-link a {
          color: #7c3aed;
          font-weight: 600;
          text-decoration: none;
          min-height: unset;
          transition: opacity 0.15s;
        }
        .register-link a:hover { opacity: 0.75; }

        /* Mobile */
        @media (max-width: 480px) {
          .login-card { padding: 2rem 1.25rem; border-radius: 20px; }
          .login-title { font-size: 1.35rem; }
        }
      `}</style>
    </div>
  )
}
