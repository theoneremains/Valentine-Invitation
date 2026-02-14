# 💖 Valentine's Day Concert Invitation - Development Guide

Welcome to the development documentation for the romantic DKTT Concert invitation app! This guide will help you understand, customize, and extend this special Vue.js application.

## 🚀 Quick Start

### Prerequisites
- Node.js 18 or higher
- npm or yarn package manager
- Git (optional, for version control)
- A loving heart 💕

### Installation

1. **Quick Setup** (Recommended):
   ```bash
   ./setup.sh install
   ```

2. **Manual Setup**:
   ```bash
   npm install
   npm run dev
   ```

3. **Start Development**:
   ```bash
   ./setup.sh dev
   # or
   npm run dev
   ```

## 📁 Project Structure

```
Valentine/
├── src/
│   ├── components/          # Vue components
│   │   ├── QuestionCard.vue    # Main question display
│   │   ├── MovingButton.vue    # Interactive "No" button
│   │   └── SuccessPage.vue     # Celebration page
│   ├── data/
│   │   └── responses.js        # Text content and configurations
│   ├── styles/
│   │   └── main.css           # Main stylesheet
│   ├── App.vue                # Root component
│   └── main.js                # Application entry point
├── public/
│   ├── index.html             # HTML template
│   └── heart-favicon.svg      # Custom favicon
├── PROJECT_REQUIREMENTS.md    # Original requirements
├── README.md                  # Project documentation
└── setup.sh                   # Setup and build script
```

## 🎨 Customization Guide

### 1. Changing the Question

Edit `src/App.vue`:
```javascript
// Change the main question
mainQuestion: "Your custom romantic question here?",
subtitle: "Your custom subtitle here",
```

### 2. Customizing Button Responses

Edit `src/data/responses.js`:
```javascript
// Add more "No" responses
export const noPrompts = [
  "Your custom no response 1",
  "Your custom no response 2",
  // ... add more
];

// Add more progressive "Yes" responses
export const yesTexts = [
  "Yes",
  "Of course my love",
  "Your custom romantic yes response",
  // ... add more
];
```

### 3. Styling and Colors

Edit CSS custom properties in `src/styles/main.css`:
```css
:root {
  --primary-color: #ff6b9d;      /* Main pink color */
  --secondary-color: #ff8a80;    /* Secondary pink */
  --accent-color: #ffc1cc;       /* Light pink accent */
  --success: #48bb78;            /* Success green */
  
  /* Change fonts */
  --font-primary: 'Your Font', sans-serif;
  --font-romantic: 'Your Romantic Font', cursive;
}
```

### 4. Adding New Visual Effects

Create custom animations in your component:
```vue
<style scoped>
@keyframes yourCustomAnimation {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}

.your-element {
  animation: yourCustomAnimation 2s ease-in-out infinite;
}
</style>
```

### 5. Concert Date and Countdown

Update the concert date in `src/App.vue`:
```javascript
concertDate: "2024-12-31T20:00:00", // New Year's concert
```

## 🎭 Components Deep Dive

### QuestionCard.vue
**Purpose**: Displays the main question with decorative elements
**Props**: 
- `question` (String): The main romantic question
- `subtitle` (String): Supporting text
- `funFact` (String): Random fun fact to display
- `attemptCount` (Number): Number of "no" clicks
- `showProgress` (Boolean): Show progress bar

**Key Features**:
- Animated entrance
- Progress bar showing "heart listening" percentage
- Decorative floating hearts
- Responsive design

### MovingButton.vue
**Purpose**: The interactive "No" button that moves around
**Props**:
- `text` (String): Button text
- `position` (Object): {x, y} coordinates
- `fontSize` (Number): Text size multiplier
- `emoji` (String): Emoji to display
- `moveOnHover` (Boolean): Move when hovered
- `wiggleOnHover` (Boolean): Wiggle animation on hover

**Events**:
- `@click`: When button is clicked
- `@move`: When button position changes
- `@hover`: When button is hovered

### SuccessPage.vue
**Purpose**: Celebration page when "Yes" is clicked
**Props**:
- `noClickCount` (Number): How many times "no" was clicked
- `finalYesText` (String): The final "yes" message
- `showCountdown` (Boolean): Show countdown timer
- `concertDate` (String): ISO date string for concert
- `showMusicControl` (Boolean): Show music control button

**Features**:
- Confetti animation
- Countdown timer
- Calendar integration
- Social sharing
- Download memento option

## 🎪 Adding New Features

### 1. Sound Effects

Add audio files to `public/` directory and update components:
```javascript
// In your component
playCelebrationSound() {
  const audio = new Audio('/your-sound.mp3');
  audio.volume = 0.3;
  audio.play().catch(() => {
    // Handle errors gracefully
  });
}
```

### 2. Database Integration

Replace localStorage with real database:
```javascript
// Example API integration
async saveUserResponse(response) {
  try {
    await fetch('/api/responses', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(response)
    });
  } catch (error) {
    console.error('Save failed:', error);
    // Fallback to localStorage
    localStorage.setItem('valentine_response', JSON.stringify(response));
  }
}
```

### 3. Multilingual Support

Create language files and use Vue i18n:
```javascript
// languages/en.js
export default {
  question: "Would you like to come to the DKTT Concert with me?",
  subtitle: "Would you like to spend this special night together?",
  // ... more translations
}
```

### 4. Advanced Animations

Use libraries like GSAP for complex animations:
```bash
npm install gsap
```

```javascript
import { gsap } from 'gsap';

// In your component method
createAdvancedAnimation() {
  gsap.to('.heart', {
    rotation: 360,
    scale: 1.5,
    duration: 2,
    ease: "back.out(1.7)"
  });
}
```

## 🧪 Testing

### Running Tests
```bash
# Install testing dependencies (if added)
npm install --save-dev @vue/test-utils vitest

# Run tests
npm run test
```

### Manual Testing Checklist
- [ ] Question displays correctly
- [ ] "No" button moves when clicked/hovered
- [ ] "Yes" button text progresses with each "no" click
- [ ] Success page shows after "yes" click
- [ ] Floating hearts animate properly
- [ ] Mobile responsiveness works
- [ ] Data saves to localStorage
- [ ] All animations are smooth

## 📱 Mobile Optimization

### Responsive Breakpoints
- **Desktop**: > 768px - Full interactive experience
- **Tablet**: 768px - 480px - Adapted layout
- **Mobile**: < 480px - Simplified interactions

### Mobile-Specific Features
- Touch-friendly button sizes
- Simplified animations for performance
- Fallback static positioning for "No" button
- Optimized font sizes

## 🚀 Deployment Options

### 1. GitHub Pages (Free)
```bash
./setup.sh deploy
# Follow the GitHub Pages setup in README.md
```

### 2. Netlify (Free)
1. Connect your GitHub repository
2. Build command: `npm run build`
3. Publish directory: `dist`

### 3. Vercel (Free)
1. Import project from GitHub
2. Framework preset: Vue.js
3. Build command: `npm run build`
4. Output directory: `dist`

### 4. Traditional Web Hosting
```bash
npm run build
# Upload contents of 'dist' folder to your web server
```

## 🎯 Performance Tips

### 1. Optimize Images
- Use WebP format for better compression
- Lazy load images below the fold
- Use appropriate sizes for different devices

### 2. Code Splitting
```javascript
// Lazy load components
const SuccessPage = () => import('./components/SuccessPage.vue');
```

### 3. Animation Performance
- Use CSS transforms instead of changing layout properties
- Use `will-change` for elements that will be animated
- Prefer `transform` and `opacity` for smooth animations

### 4. Bundle Optimization
```javascript
// vite.config.js
export default defineConfig({
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['vue'],
          components: ['./src/components/SuccessPage.vue']
        }
      }
    }
  }
});
```

## 🐛 Troubleshooting

### Common Issues

**1. "No" button doesn't move on mobile**
- Check if the component is using relative positioning fallback
- Verify touch events are properly handled

**2. Animations are choppy**
- Reduce the number of floating elements
- Use CSS `transform` instead of changing `top`/`left`
- Enable hardware acceleration with `transform3d`

**3. Build fails**
- Check Node.js version (requires 18+)
- Clear node_modules and reinstall: `./setup.sh clean`
- Check for TypeScript errors in console

**4. localStorage not working**
- Check browser privacy settings
- Test in incognito mode
- Implement fallback storage mechanism

## 🎨 Design System

### Color Palette
```css
/* Primary Colors */
--primary-color: #ff6b9d;    /* Hot Pink */
--secondary-color: #ff8a80;  /* Light Pink */
--accent-color: #ffc1cc;     /* Pale Pink */

/* Semantic Colors */
--success: #48bb78;          /* Green */
--warning: #ed8936;          /* Orange */
--error: #e53e3e;           /* Red */

/* Neutral Colors */
--white: #ffffff;
--dark: #2d3748;
--gray-light: #f7fafc;
```

### Typography Scale
```css
/* Font Sizes */
--text-xs: 0.75rem;    /* 12px */
--text-sm: 0.875rem;   /* 14px */
--text-base: 1rem;     /* 16px */
--text-lg: 1.125rem;   /* 18px */
--text-xl: 1.25rem;    /* 20px */
--text-2xl: 1.5rem;    /* 24px */
--text-3xl: 1.875rem;  /* 30px */
--text-4xl: 2.25rem;   /* 36px */
```

### Spacing System
```css
/* Spacing Scale */
--space-1: 0.25rem;    /* 4px */
--space-2: 0.5rem;     /* 8px */
--space-3: 0.75rem;    /* 12px */
--space-4: 1rem;       /* 16px */
--space-5: 1.25rem;    /* 20px */
--space-6: 1.5rem;     /* 24px */
--space-8: 2rem;       /* 32px */
--space-10: 2.5rem;    /* 40px */
```

## 📚 Learning Resources

### Vue.js Resources
- [Vue.js Official Guide](https://vuejs.org/guide/)
- [Vue.js Composition API](https://vuejs.org/guide/extras/composition-api-faq.html)
- [Vue.js Best Practices](https://vuejs.org/style-guide/)

### CSS Animation Resources
- [CSS Animation Guide](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations)
- [Easing Functions](https://easings.net/)
- [Animation Performance](https://web.dev/animations/)

### Romantic Development Tips 💕
- Test with your loved one for the best user experience
- Pay attention to small details that show you care
- Make it personal with custom messages
- Keep the interactions playful and fun
- Don't forget to express genuine emotions

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes with love 💕
4. Test thoroughly on different devices
5. Commit with descriptive messages
6. Push to your fork: `git push origin feature/amazing-feature`
7. Create a Pull Request

### Code Style Guidelines
- Use meaningful variable and function names
- Add comments for complex romantic logic
- Follow Vue.js style guide
- Keep components focused and reusable
- Write code with love and attention to detail

---

## 💝 Final Notes

This application was created with love and attention to detail. Every animation, every interaction, and every message was carefully crafted to create a memorable and romantic experience.

Remember, the most important part isn't the code - it's the genuine emotion and care you put into sharing this with someone special. 

May your romantic invitation be successful! 💖

---

**Happy coding, and happy loving! 💕**

*Created with 💖 for spreading love through code*