import React from 'react'

export default function Footer() {
  return (
    <footer className="bg-gray-100">
      <div className="max-w-6xl mx-auto px-4 py-8 text-center text-gray-600">
        © {new Date().getFullYear()} App Nuoc Hoa. All rights reserved.
      </div>
    </footer>
  )
}
