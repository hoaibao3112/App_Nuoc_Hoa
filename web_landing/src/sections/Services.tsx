import React from 'react'

const items = [
  { title: 'Tư vấn hương', desc: 'Chọn mùi theo cá tính.' },
  { title: 'Thử mẫu tại nhà', desc: 'Giao mẫu dùng thử.' },
  { title: 'Gói quà sang', desc: 'Đóng gói quà chuyên nghiệp.' },
]

export default function Services() {
  return (
    <div id="services">
      <h2 className="text-2xl font-semibold mb-6">Dịch vụ</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {items.map((it) => (
          <div key={it.title} className="p-6 border rounded-lg bg-white shadow-sm">
            <h3 className="font-semibold">{it.title}</h3>
            <p className="mt-2 text-gray-600">{it.desc}</p>
          </div>
        ))}
      </div>
    </div>
  )
}
