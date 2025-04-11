import { vitePreprocess } from '@sveltejs/vite-plugin-svelte'

export default {
  // Consult https://svelte.dev/docs#compile-time-svelte-preprocess
  // for more information about preprocessors
  preprocess: vitePreprocess(),

  vite: () => ({
    server: {
      port: 80,
      host: true,
      hmr: {
        clientPort: 443
      },
    }    
  })
}