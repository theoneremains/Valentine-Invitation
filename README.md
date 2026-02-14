# 💖 Valentine's Day DKTT Concert Invitation

A romantic and interactive Vue.js web application designed as a playful invitation to a DKTT Concert. This project creates an engaging experience where the "No" button playfully evades the user while the "Yes" button becomes increasingly romantic.

## ✨ Features

- **Interactive Question**: Romantic concert invitation with two response options
- **Playful "No" Button**: Moves around the screen and shows different prompts when clicked
- **Progressive "Yes" Button**: Becomes more loving with each "No" attempt
- **Success Animation**: Beautiful confirmation page with heart animations
- **Responsive Design**: Works perfectly on all devices
- **Database Integration**: Stores user responses and interaction data

## 🚀 Live Demo

[View Live Demo](https://your-github-username.github.io/Valentine) *(Coming Soon)*

## 🛠️ Technologies Used

- **Vue.js 3** - Progressive JavaScript framework
- **CSS3** - Advanced animations and transitions
- **HTML5** - Semantic markup
- **JavaScript ES6+** - Modern JavaScript features
- **Firebase/MongoDB** - Database for storing responses *(Optional)*

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/Valentine.git
cd Valentine
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```

4. Open your browser and navigate to `http://localhost:3000`

## 🎯 How It Works

1. **Main Question**: User sees "Benimle DKTT Konserine Gelmek İster misiniz Hanımefendi?"
2. **Interactive Responses**: 
   - "Hayır" button moves around and shows different prompts
   - "Evet" button becomes more romantic with each interaction
3. **Success Page**: Beautiful confirmation with animations when "Yes" is selected
4. **Data Storage**: User responses are saved to database

## 🎨 Customization

### Modifying Button Texts

Edit the arrays in `src/data/responses.js`:

```javascript
// "No" button prompts
export const noPrompts = [
  "Emin misiniz?",
  "Gerçekten mi?",
  "Bir daha düşünür müsünüz?"
];

// Progressive "Yes" button texts
export const yesTexts = [
  "Evet",
  "Tabii ki hayatım",
  "Buna nasıl hayır diyebilirim?"
];
```

### Styling

Modify colors and animations in `src/styles/main.css` or component-specific styles.

## 📁 Project Structure

```
Valentine/
├── src/
│   ├── components/
│   │   ├── QuestionCard.vue
│   │   ├── MovingButton.vue
│   │   └── SuccessPage.vue
│   ├── data/
│   │   └── responses.js
│   ├── styles/
│   │   └── main.css
│   ├── App.vue
│   └── main.js
├── public/
│   ├── index.html
│   └── favicon.ico
├── PROJECT_REQUIREMENTS.md
├── package.json
└── README.md
```

## 🚀 Deployment

### GitHub Pages

1. Build the project:
```bash
npm run build
```

2. Deploy to GitHub Pages:
```bash
npm run deploy
```

### Manual Deployment

1. Build the project: `npm run build`
2. Upload the `dist` folder to your hosting provider

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/AmazingFeature`
3. Commit your changes: `git commit -m 'Add some AmazingFeature'`
4. Push to the branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💝 Special Thanks

Created with love for a special someone. May this playful invitation bring joy and smiles! 

## 📧 Contact

- **Developer**: Kamil Özkaya
- **Email**: [your-email@example.com]
- **GitHub**: [@your-username](https://github.com/your-username)

---

*"Love is in the details, and every click is a step closer to 'Yes'!"* 💕