module.exports = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: '#1E3A5F',
        accent: '#F5A623',
        ink: '#0B1220',
        sand: '#F7F3EE'
      },
      fontFamily: {
        heading: ['Playfair Display', 'serif'],
        body: ['Inter', 'sans-serif']
      },
      boxShadow: {
        glow: '0 10px 30px rgba(30, 58, 95, 0.25)'
      }
    }
  },
  plugins: []
}
