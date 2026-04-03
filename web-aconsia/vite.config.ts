import { defineConfig } from 'vite'
import path from 'path'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [
    // The React and Tailwind plugins are both required for Make, even if
    // Tailwind is not being actively used – do not remove them
    react(),
    tailwindcss(),
  ],
  resolve: {
    alias: {
      // Alias @ to the src directory
      '@': path.resolve(__dirname, './src'),
    },
  },
  build: {
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (!id.includes('node_modules')) return undefined

          if (
            id.includes('/node_modules/firebase/') ||
            id.includes('/node_modules/@firebase/')
          ) {
            return 'vendor-firebase'
          }

          if (
            id.includes('/node_modules/react/') ||
            id.includes('/node_modules/react-dom/') ||
            id.includes('/node_modules/react-router/')
          ) {
            return 'vendor-react'
          }

          if (
            id.includes('/node_modules/@mui/') ||
            id.includes('/node_modules/@emotion/')
          ) {
            return 'vendor-mui'
          }

          if (id.includes('/node_modules/@radix-ui/')) {
            return 'vendor-radix'
          }

          if (
            id.includes('/node_modules/lucide-react/') ||
            id.includes('/node_modules/motion/')
          ) {
            return 'vendor-ui-motion-icons'
          }

          if (
            id.includes('/node_modules/recharts/') ||
            id.includes('/node_modules/d3-')
          ) {
            return 'vendor-charts'
          }

          if (
            id.includes('/node_modules/jspdf/') ||
            id.includes('/node_modules/jspdf-autotable/')
          ) {
            return 'vendor-pdf'
          }

          return undefined
        },
      },
    },
  },

  // File types to support raw imports. Never add .css, .tsx, or .ts files to this.
  assetsInclude: ['**/*.svg', '**/*.csv'],
})
