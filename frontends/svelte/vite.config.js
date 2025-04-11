import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [svelte()],
  server: {
    host: true,
    port: 80,
    allowedHosts: [
      'fieldtwin-integration-frontendsvelte.lvh.me',
      'kr1s-z-fieldtwin-integration-frontendsvelte.futureon-dev.fieldtwin.com',
      'localhost',
      '0.0.0.0',
    ],
  },
})
