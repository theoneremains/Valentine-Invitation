import { createApp } from 'vue'
import App from './App.vue'
import './styles/main.css'

// Create Vue application
const app = createApp(App)

// Global error handler
app.config.errorHandler = (err, vm, info) => {
  console.error('Vue Error:', err)
  console.error('Component:', vm)
  console.error('Error Info:', info)
}

// Global properties (if needed)
app.config.globalProperties.$heartEmojis = ['💖', '💕', '💗', '💓', '💝', '💘', '💟', '❤️', '🧡', '💛', '💚', '💙', '💜', '🤍', '🖤', '🤎']

// Mount the application
app.mount('#app')

// Add some global event listeners for enhanced interactivity
document.addEventListener('DOMContentLoaded', () => {
  // Add click effect to body for sparkles
  document.body.addEventListener('click', (e) => {
    createClickSparkle(e.clientX, e.clientY)
  })

  // Add mouse move effect for subtle interactions
  document.body.addEventListener('mousemove', (e) => {
    createMouseTrail(e.clientX, e.clientY)
  })
})

// Helper function to create sparkle effect on click
function createClickSparkle(x, y) {
  const sparkle = document.createElement('div')
  sparkle.className = 'click-sparkle'
  sparkle.style.cssText = `
    position: fixed;
    left: ${x}px;
    top: ${y}px;
    width: 8px;
    height: 8px;
    background: linear-gradient(45deg, #ff6b9d, #ff8a80);
    border-radius: 50%;
    pointer-events: none;
    z-index: 9999;
    animation: clickSparkle 0.6s ease-out forwards;
  `

  document.body.appendChild(sparkle)

  setTimeout(() => {
    sparkle.remove()
  }, 600)
}

// Helper function to create subtle mouse trail
let trailTimeout
function createMouseTrail(x, y) {
  // Throttle the trail creation
  clearTimeout(trailTimeout)
  trailTimeout = setTimeout(() => {
    if (Math.random() > 0.95) { // Only create trail occasionally
      const trail = document.createElement('div')
      trail.className = 'mouse-trail'
      trail.style.cssText = `
        position: fixed;
        left: ${x}px;
        top: ${y}px;
        width: 4px;
        height: 4px;
        background: rgba(255, 255, 255, 0.6);
        border-radius: 50%;
        pointer-events: none;
        z-index: 1;
        animation: fadeTrail 1s ease-out forwards;
      `

      document.body.appendChild(trail)

      setTimeout(() => {
        trail.remove()
      }, 1000)
    }
  }, 50)
}

// Add CSS for dynamic effects
const dynamicStyles = `
  @keyframes clickSparkle {
    0% {
      opacity: 1;
      transform: scale(0) rotate(0deg);
    }
    50% {
      opacity: 1;
      transform: scale(1.5) rotate(180deg);
    }
    100% {
      opacity: 0;
      transform: scale(0) rotate(360deg);
    }
  }

  @keyframes fadeTrail {
    0% {
      opacity: 0.6;
      transform: scale(1);
    }
    100% {
      opacity: 0;
      transform: scale(0.3);
    }
  }
`

// Add dynamic styles to head
const styleSheet = document.createElement('style')
styleSheet.textContent = dynamicStyles
document.head.appendChild(styleSheet)

// Console message for developers
console.log(`
💖 Valentine's Day Concert Invitation App
Created with love for someone special
Built with Vue.js 3 & Vite
`)

// Performance monitoring (optional)
if (window.performance) {
  window.addEventListener('load', () => {
    setTimeout(() => {
      const perfData = performance.getEntriesByType('navigation')[0]
      console.log(`⚡ App loaded in ${Math.round(perfData.loadEventEnd - perfData.fetchStart)}ms`)
    }, 0)
  })
}

// PWA service worker registration (if service worker exists)
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then((registration) => {
        console.log('💝 Service Worker registered successfully')
      })
      .catch((error) => {
        // Silent fail for service worker
      })
  })
}

// Prevent right-click context menu for better UX (optional)
document.addEventListener('contextmenu', (e) => {
  e.preventDefault()
})

// Add keyboard shortcuts for fun
document.addEventListener('keydown', (e) => {
  // Easter egg: Press 'L' for Love
  if (e.key.toLowerCase() === 'l') {
    createFloatingHeart()
  }

  // Press 'H' for Heart shower
  if (e.key.toLowerCase() === 'h') {
    for (let i = 0; i < 10; i++) {
      setTimeout(() => createFloatingHeart(), i * 100)
    }
  }
})

function createFloatingHeart() {
  const hearts = ['💖', '💕', '💗', '💓', '💝', '💘']
  const heart = document.createElement('div')
  heart.textContent = hearts[Math.floor(Math.random() * hearts.length)]
  heart.style.cssText = `
    position: fixed;
    left: ${Math.random() * window.innerWidth}px;
    top: ${window.innerHeight + 20}px;
    font-size: 1.5rem;
    pointer-events: none;
    z-index: 1000;
    animation: floatUp 3s ease-out forwards;
  `

  document.body.appendChild(heart)

  setTimeout(() => {
    heart.remove()
  }, 3000)
}
