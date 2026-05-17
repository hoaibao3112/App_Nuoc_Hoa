import React from 'react'

const testimonials = [
  { name: 'Lan', text: 'Dịch vụ tuyệt vời!' },
  { name: 'Mai', text: 'Giao hàng nhanh, mùi thơm phù hợp.' },
]

export default function Testimonials() {
  return (
    <div id="testimonials">
      <h2 className="text-2xl font-semibold mb-6">Đánh giá khách hàng</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {testimonials.map((t) => (
          <div key={t.name} className="p-6 border rounded-lg bg-white shadow-sm">
            <div className="font-semibold">{t.name}</div>
            <p className="mt-2 text-gray-600">{t.text}</p>
          </div>
        ))}
      </div>
    </div>
  )
}
