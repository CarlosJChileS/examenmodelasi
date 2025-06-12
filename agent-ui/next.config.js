/** @type {import('next').NextConfig} */
const nextConfig = {
  typescript: {
    ignoreBuildErrors: true,
  },
  output: 'export', // Esto es lo que permite exportar a /out
}

module.exports = nextConfig
