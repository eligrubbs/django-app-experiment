import { build, defineConfig } from 'vite';
import tailwindcss from '@tailwindcss/vite';
import path from 'path';


export default defineConfig({
  root: 'frontend',
  base: '/static/', // Should match Django's STATIC_URL
  plugins: [
    tailwindcss(),
  ],

  build: {
    outDir: path.resolve(__dirname, './static'), // Place in same folder as non-vite assets. Matches a Django STATICFILES_DIRS entry
    emptyOutDir: false,
    manifest: true,

    rolldownOptions: {

      input: {
        'app': path.resolve(__dirname, 'frontend/src/css/app.css'),
        'index': path.resolve(__dirname, 'frontend/src/js/index.js'),
      },

      output: {
        // Want stable names for the main files
        entryFileNames: `js/[name].js`,
        // Prevents filename collisions that I am not smart enough to forsee
        chunkFileNames: `js/[name]-[hash].js`,
        assetFileNames: (assetInfo) => {
          if (assetInfo.names?.some(name => name.endsWith('.css'))) {
            return 'css/[name][extname]'
          }
          return `[ext]/[name]-[extname]`;
        }
      }
    },
  },

  resolve: {
    alias: {
        '@': path.resolve(__dirname, 'frontend'),
    },
  },
})
