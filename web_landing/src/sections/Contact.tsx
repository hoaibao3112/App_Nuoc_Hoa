import React from 'react'

export default function Contact() {
  return (
    <div id="contact">
      <h2 className="text-2xl font-semibold mb-6">Liên hệ</h2>
      <form className="grid grid-cols-1 gap-4">
        <input className="p-3 border rounded" placeholder="Họ và tên" />
        <input className="p-3 border rounded" placeholder="Email" type="email" />
        <textarea className="p-3 border rounded" placeholder="Nội dung" rows={4}></textarea>
        <button className="bg-primary text-white py-3 rounded w-44">Gửi</button>
      </form>
    </div>
  )
}
