import React from 'react'
import NavBar from '../shared/NavBar'
import Hero from '../sections/Hero'
import Services from '../sections/Services'
import Pricing from '../sections/Pricing'
import Testimonials from '../sections/Testimonials'
import Contact from '../sections/Contact'
import Footer from '../shared/Footer'

export default function Home() {
  return (
    <div className="min-h-screen flex flex-col font-body text-gray-900 bg-white">
      <NavBar />
      <main className="flex-1">
        <Hero />
        <section className="max-w-6xl mx-auto px-4 py-12">
          <Services />
        </section>
        <section className="bg-gray-50">
          <div className="max-w-6xl mx-auto px-4 py-12">
            <Pricing />
          </div>
        </section>
        <section className="max-w-6xl mx-auto px-4 py-12">
          <Testimonials />
        </section>
        <section className="max-w-4xl mx-auto px-4 py-12">
          <Contact />
        </section>
      </main>
      <Footer />
    </div>
  )
}
