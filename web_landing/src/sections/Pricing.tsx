import React from 'react'
import { Button } from '../components/ui/button'
import { Card, CardContent, CardHeader } from '../components/ui/card'

const plans = [
  { name: 'Cơ bản', price: '199K', features: ['Tư vấn', '1 mẫu'] },
  { name: 'Cao cấp', price: '499K', features: ['Tư vấn', '3 mẫu', 'Gói quà'] },
  { name: 'Doanh nghiệp', price: 'Liên hệ', features: ['Sự kiện', 'Bulk'] },
]

export default function Pricing() {
  return (
    <div id="pricing">
      <h2 className="text-2xl font-semibold mb-6">Bảng giá</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {plans.map((p) => (
          <Card key={p.name} className="overflow-hidden">
            <CardHeader>
              <div className="text-lg font-semibold">{p.name}</div>
              <div className="text-2xl mt-2 text-primary">{p.price}</div>
            </CardHeader>
            <CardContent>
              <ul className="mt-2 text-gray-600 space-y-2">
                {p.features.map((f) => (
                  <li key={f}>• {f}</li>
                ))}
              </ul>
              <Button className="mt-6 w-full">Chọn gói</Button>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  )
}
