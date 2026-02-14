// Response data for the Valentine's Day invitation app

// Messages that appear on the "No" button when it's clicked
export const noPrompts = [
  "Hayır",
  "Vay SuperGirl bu tuşa nasıl bastın? Hayır mı gerçekten?",
  "Giiiiiiiitmeeeeee Kaaaaaallll 🎵 Hala hayır?",
  "Yapmaaa Nolursun. Hayır?",
  "Lütfen tekrar düşün",
  "Son kararın mı?",
  "Beni üzecek misin?",
  "Kalbimi kıracak mısın?",
  "Belki fikrini değiştirirsin?",
  "Bu kadar kesin misin?",
  "Vazgeçtin mi gerçekten?",
  "Hiç şansım yok mu?",
  "Beni bu kadar kolay mı reddediyorsun?",
];

// Progressive loving messages for the "Yes" button
export const yesTexts = [
  "Evet",
  "Tabii ki!",
  "Tabii ki hayatım",
  "Buna nasıl hayır diyebilirim?",
  "Hayır diyemem, çünkü seni seviyorum",
  "Seninle her yere gelirim aşkım",
  "Sen istersen dünyanın öbür ucuna bile gelirim",
  "Seni seviyorum, tabii ki geleceğim!",
  "Aşkım, sen varsan her yer cennet",
  "Hayatımın anlamı, elbette kabul ediyorum!",
  "Sonsuz aşkımla, evet diyorum!",
  "Kalbim seninle, tabii ki evet!",
];

// Success page messages
export const successMessages = [
  "Teşekkürler Hanfendi!",
  "Seni tüm kalbimle seviyorum.",
  "Seninle geçireceğim her an değerli.",
];

// Romantic compliments that appear during interactions
export const compliments = [
  "Gözlerin yıldızlar kadar parlak ✨",
  "Gülüşün kalbimi hızlandırıyor 💓",
  "Sen benim dünyamın güneşisin ☀️",
  "Aşkımız sonsuzluğa kadar 💫",
  "Her nefesimde sen varsın 💝",
  "Kalbim sadece senin için atıyor 💗",
  "Sen benim hayatımın melodisisin 🎵",
  "Aşkımız zamanı durduruyor ⏰",
  "Seninle her şey mükemmel 🌹",
  "Ruhum seninle huzur buluyor 🕊️",
];

// Fun facts about the relationship or concert
export const funFacts = [
  "DKTT'nin senin favori şarkılarını çalacağını biliyorum 🎶",
  "Seninle yan yana keyifle dinlediğimizi hayal ediyorum 💃",
];

// Random position generator for moving button
export const getRandomPosition = (buttonWidth = 120, buttonHeight = 50) => {
  const margin = 20;
  const maxX = window.innerWidth - buttonWidth - margin;
  const maxY = window.innerHeight - buttonHeight - margin;

  return {
    x: Math.max(margin, Math.random() * maxX),
    y: Math.max(margin, Math.random() * maxY),
  };
};

// Animation configurations
export const animations = {
  buttonMove: {
    duration: 800,
    easing: "cubic-bezier(0.68, -0.55, 0.265, 1.55)",
  },
  heartFloat: {
    duration: 3000,
    delay: Math.random() * 2000,
  },
  confetti: {
    particleCount: 100,
    spread: 70,
    origin: { y: 0.6 },
  },
};

// Color themes
export const colors = {
  primary: "#ff6b9d",
  secondary: "#ff8a80",
  accent: "#ffc1cc",
  white: "#ffffff",
  dark: "#2d3748",
  success: "#48bb78",
  gradient: "linear-gradient(135deg, #ff6b9d, #ff8a80, #ffc1cc)",
};
