import React from 'react'
import { motion } from 'framer-motion'
import { Button } from '../components/ui/button'

export default function Hero() {
  return (
    <section className="bg-gradient-to-b from-white to-sand py-16">
      <div className="max-w-6xl mx-auto px-4 grid grid-cols-1 md:grid-cols-2 gap-8 items-center">
        <div>
          <motion.h1 initial={{ y: 10, opacity: 0 }} animate={{ y: 0, opacity: 1 }} transition={{ duration: 0.6 }} className="text-3xl md:text-5xl font-heading text-primary">
            Hương thơm hoàn hảo cho từng khoảnh khắc
          </motion.h1>
          <p className="mt-4 text-gray-700">Dịch vụ chọn nước hoa cá nhân hoá, giao nhanh tại TP.</p>
          <div className="mt-6 flex gap-4">
            <Button asChild className="shadow-glow"><a href="#contact">Đặt ngay</a></Button>
            <Button asChild variant="outline"><a href="#services">Tìm hiểu</a></Button>
          </div>
        </div>
        <div className="order-first md:order-last">
          <div className="w-full h-60 md:h-80 bg-gradient-to-r from-primary to-accent rounded-lg shadow-lg" />
        </div>
      </div>
    </section>
  )
}
