<template>
    <div class="success-page">
        <!-- Main Success Message -->
        <div class="success-header">
            <h1 class="success-title">{{ successTitle }}</h1>
            <p class="success-subtitle">{{ successSubtitle }}</p>
        </div>

        <!-- Animated Heart -->
        <div class="heart-container">
            <div class="beating-heart">💖</div>
            <div class="heart-shape"></div>
        </div>

        <!-- Success Details -->
        <div class="success-details">
            <div class="message-card">
                <p class="romantic-message">{{ romanticMessage }}</p>
                <p class="concert-details">{{ concertDetails }}</p>
            </div>

            <!-- Fun Facts Section -->
            <div class="fun-facts">
                <h3>💕 Neden Bu Kadar Özel?</h3>
                <div class="fact-list">
                    <div
                        v-for="(fact, index) in displayedFacts"
                        :key="index"
                        class="fact-item"
                    >
                        <span class="fact-icon">{{ fact.icon }}</span>
                        <span class="fact-text">{{ fact.text }}</span>
                    </div>
                </div>
            </div>

            <!-- Countdown Timer -->
            <div v-if="showCountdown" class="countdown-section">
                <h3>⏰ Konsere Kalan Süre</h3>
                <div class="countdown-timer">
                    <div class="time-unit">
                        <span class="time-number">{{ countdown.days }}</span>
                        <span class="time-label">Gün</span>
                    </div>
                    <div class="time-unit">
                        <span class="time-number">{{ countdown.hours }}</span>
                        <span class="time-label">Saat</span>
                    </div>
                    <div class="time-unit">
                        <span class="time-number">{{ countdown.minutes }}</span>
                        <span class="time-label">Dakika</span>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <button class="btn btn-primary" @click="saveToCalendar">
                    📅 Takvime Ekle
                </button>
                <button class="btn btn-secondary" @click="shareExperience">
                    💕 Paylaş
                </button>
                <button class="btn btn-outline" @click="downloadMemento">
                    🎁 Anı İndir
                </button>
            </div>

            <!-- Restart Option -->
            <div class="restart-section">
                <p class="restart-text">Tekrar yaşamak ister misin ;)</p>
                <button class="btn btn-restart" @click="$emit('restart')">
                    🔄 Yeniden Başla
                </button>
            </div>
        </div>

        <!-- Floating Elements -->
        <div class="floating-elements">
            <div
                v-for="element in floatingElements"
                :key="element.id"
                class="floating-element"
                :style="{
                    left: element.x + 'px',
                    top: element.y + 'px',
                    animationDelay: element.delay + 's',
                    fontSize: element.size + 'rem',
                }"
            >
                {{ element.symbol }}
            </div>
        </div>

        <!-- Confetti Canvas -->
        <canvas
            ref="confettiCanvas"
            class="confetti-canvas"
            :width="canvasWidth"
            :height="canvasHeight"
        ></canvas>

        <!-- Background Music Control -->
        <div class="music-control" v-if="showMusicControl">
            <button
                class="music-button"
                @click="toggleMusic"
                :class="{ active: isMusicPlaying }"
            >
                <span v-if="isMusicPlaying">🔊</span>
                <span v-else>🔇</span>
                <span class="music-label">Romantik Müzik</span>
            </button>
        </div>
    </div>
</template>

<script>
import { successMessages, funFacts } from "../data/responses.js";

export default {
    name: "SuccessPage",
    props: {
        noClickCount: {
            type: Number,
            default: 0,
        },
        finalYesText: {
            type: String,
            default: "Evet",
        },
        showCountdown: {
            type: Boolean,
            default: true,
        },
        concertDate: {
            type: String,
            default: "2024-02-14T20:00:00", // Default Valentine's Day
        },
        showMusicControl: {
            type: Boolean,
            default: false,
        },
    },
    emits: ["restart", "save-calendar", "share", "download"],
    data() {
        return {
            successTitle: "Teşekkürler Hanımefendi!",
            successSubtitle: "Seni tüm kalbimle seviyorum 💕",
            romanticMessage: "Seninle geçireceğim her an değerli.",
            concertDetails: "DKTT Konseri - Romantik bir gece bizi bekliyor 🎵",

            floatingElements: [],
            countdown: {
                days: 0,
                hours: 0,
                minutes: 0,
                seconds: 0,
            },
            countdownInterval: null,

            canvasWidth: 0,
            canvasHeight: 0,
            confettiParticles: [],
            animationFrame: null,

            isMusicPlaying: false,
            audioElement: null,

            displayedFacts: [
                {
                    icon: "🎫",
                    text: "Kalın Giyinmeyi Unutma Üşütmeni İstemeyiz ;)",
                },
                {
                    icon: "🎶",
                    text: "DKTT'nin senin favori şarkılarını çalacağını biliyorum",
                },
                {
                    icon: "🎼",
                    text: "Dilerim ki asla caymazsın benim olmaktan",
                },
            ],
        };
    },

    mounted() {
        this.initializeCanvas();
        this.createFloatingElements();
        this.startConfetti();
        this.startCountdown();
        this.customizeMessageForAttempts();

        // Add window resize listener
        window.addEventListener("resize", this.handleResize);
    },

    beforeUnmount() {
        this.clearTimers();
        window.removeEventListener("resize", this.handleResize);
    },

    methods: {
        initializeCanvas() {
            this.canvasWidth = window.innerWidth;
            this.canvasHeight = window.innerHeight;
            this.$nextTick(() => {
                this.setupConfetti();
            });
        },

        handleResize() {
            this.canvasWidth = window.innerWidth;
            this.canvasHeight = window.innerHeight;
        },

        createFloatingElements() {
            const symbols = [
                "💖",
                "💕",
                "💗",
                "💓",
                "💝",
                "💘",
                "✨",
                "🌟",
                "💫",
                "🎵",
                "🎶",
            ];

            for (let i = 0; i < 15; i++) {
                this.floatingElements.push({
                    id: i,
                    symbol: symbols[Math.floor(Math.random() * symbols.length)],
                    x: Math.random() * window.innerWidth,
                    y: window.innerHeight + 20,
                    delay: Math.random() * 3,
                    size: 1 + Math.random() * 1.5,
                });
            }

            // Create new elements periodically
            setInterval(() => {
                this.addFloatingElement();
            }, 2000);
        },

        addFloatingElement() {
            if (this.floatingElements.length > 20) {
                this.floatingElements.shift();
            }

            const symbols = ["💖", "💕", "💗", "💓", "💝", "💘", "✨", "🌟"];
            this.floatingElements.push({
                id: Date.now() + Math.random(),
                symbol: symbols[Math.floor(Math.random() * symbols.length)],
                x: Math.random() * window.innerWidth,
                y: window.innerHeight + 20,
                delay: 0,
                size: 1 + Math.random() * 1.5,
            });
        },

        setupConfetti() {
            const canvas = this.$refs.confettiCanvas;
            if (!canvas) return;

            const ctx = canvas.getContext("2d");
            this.confettiParticles = [];

            // Create confetti particles
            for (let i = 0; i < 50; i++) {
                this.confettiParticles.push({
                    x: Math.random() * canvas.width,
                    y: -10,
                    vx: (Math.random() - 0.5) * 4,
                    vy: Math.random() * 3 + 2,
                    color: this.getRandomColor(),
                    size: Math.random() * 8 + 4,
                    rotation: 0,
                    rotationSpeed: (Math.random() - 0.5) * 0.2,
                });
            }

            this.animateConfetti(ctx, canvas);
        },

        animateConfetti(ctx, canvas) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            this.confettiParticles.forEach((particle, index) => {
                particle.x += particle.vx;
                particle.y += particle.vy;
                particle.rotation += particle.rotationSpeed;
                particle.vy += 0.1; // gravity

                ctx.save();
                ctx.translate(particle.x, particle.y);
                ctx.rotate(particle.rotation);
                ctx.fillStyle = particle.color;
                ctx.fillRect(
                    -particle.size / 2,
                    -particle.size / 2,
                    particle.size,
                    particle.size,
                );
                ctx.restore();

                // Reset particle if it goes off screen
                if (particle.y > canvas.height + 10) {
                    particle.x = Math.random() * canvas.width;
                    particle.y = -10;
                    particle.vy = Math.random() * 3 + 2;
                }
            });

            this.animationFrame = requestAnimationFrame(() =>
                this.animateConfetti(ctx, canvas),
            );
        },

        startConfetti() {
            setTimeout(() => {
                this.setupConfetti();
            }, 500);
        },

        getRandomColor() {
            const colors = [
                "#ff6b9d",
                "#ff8a80",
                "#ffc1cc",
                "#ffb3ba",
                "#ffdfba",
                "#ffffba",
                "#baffc9",
                "#bae1ff",
            ];
            return colors[Math.floor(Math.random() * colors.length)];
        },

        startCountdown() {
            this.updateCountdown();
            this.countdownInterval = setInterval(this.updateCountdown, 1000);
        },

        updateCountdown() {
            const now = new Date().getTime();
            const concertTime = new Date(this.concertDate).getTime();
            const distance = concertTime - now;

            if (distance > 0) {
                this.countdown = {
                    days: Math.floor(distance / (1000 * 60 * 60 * 24)),
                    hours: Math.floor(
                        (distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60),
                    ),
                    minutes: Math.floor(
                        (distance % (1000 * 60 * 60)) / (1000 * 60),
                    ),
                    seconds: Math.floor((distance % (1000 * 60)) / 1000),
                };
            }
        },

        customizeMessageForAttempts() {
            if (this.noClickCount > 10) {
                this.romanticMessage = `${this.noClickCount} kez hayır dedin ama sonunda kalbini dinledin! Bu gece çok özel olacak.`;
            } else if (this.noClickCount > 5) {
                this.romanticMessage =
                    "Biraz zor ikna olsan da, sonunda doğru kararı verdin canım!";
            } else if (this.noClickCount > 0) {
                this.romanticMessage =
                    "Kısa bir tereddütten sonra kalbin konuştu! Seni seviyorum.";
            }
        },

        saveToCalendar() {
            const event = {
                title: "DKTT Konseri - Romantik Gece",
                start: this.concertDate,
                description: "Sevgilimle unutulmaz bir konser gecesi",
            };

            // Create calendar link
            const startDate = new Date(this.concertDate);
            const endDate = new Date(startDate.getTime() + 3 * 60 * 60 * 1000); // 3 hours later

            const formatDate = (date) => {
                return (
                    date.toISOString().replace(/[-:]/g, "").split(".")[0] + "Z"
                );
            };

            const calendarUrl = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(event.title)}&dates=${formatDate(startDate)}/${formatDate(endDate)}&details=${encodeURIComponent(event.description)}`;

            window.open(calendarUrl, "_blank");
            this.$emit("save-calendar", event);
        },

        shareExperience() {
            if (navigator.share) {
                navigator.share({
                    title: "DKTT Konseri Davetiyesi",
                    text: "Sevgilime romantik bir konser davetiyesi gönderdim!",
                    url: window.location.href,
                });
            } else {
                // Fallback to copying link
                navigator.clipboard.writeText(window.location.href);
                alert("Link kopyalandı! Paylaşabilirsin 💕");
            }

            this.$emit("share");
        },

        downloadMemento() {
            // Create a simple memento image/text
            const mementoText = `
        💖 DKTT Konseri Davetiyesi 💖

        "${this.finalYesText}"

        Tarih: ${new Date(this.concertDate).toLocaleDateString("tr-TR")}

        Bu özel anı hatıralara...
        Seni seviyorum! ❤️
      `;

            const blob = new Blob([mementoText], { type: "text/plain" });
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = "DKTT_Konseri_Davetiyesi.txt";
            a.click();
            URL.revokeObjectURL(url);

            this.$emit("download");
        },

        toggleMusic() {
            if (!this.audioElement) {
                // Create audio element for background music
                this.audioElement = new Audio("/romantic-music.mp3");
                this.audioElement.loop = true;
                this.audioElement.volume = 0.3;
            }

            if (this.isMusicPlaying) {
                this.audioElement.pause();
            } else {
                this.audioElement.play().catch(() => {
                    // Handle audio play errors
                });
            }

            this.isMusicPlaying = !this.isMusicPlaying;
        },

        clearTimers() {
            if (this.countdownInterval) {
                clearInterval(this.countdownInterval);
            }
            if (this.animationFrame) {
                cancelAnimationFrame(this.animationFrame);
            }
            if (this.audioElement) {
                this.audioElement.pause();
            }
        },
    },
};
</script>

<style scoped>
.success-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    position: relative;
    overflow: hidden;
}

.success-header {
    text-align: center;
    margin-bottom: 30px;
    animation: fadeInUp 1s ease-out;
}

.success-title {
    font-family: var(--font-romantic);
    font-size: 3.5rem;
    color: var(--white);
    text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.3);
    margin-bottom: 10px;
    line-height: 1.2;
}

.success-subtitle {
    font-size: 1.5rem;
    color: var(--white);
    text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.3);
    opacity: 0.95;
}

.heart-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 20px 0;
    animation: fadeInUp 1s ease-out 0.3s both;
}

.beating-heart {
    font-size: 6rem;
    animation: heartbeat 1.5s ease-in-out infinite;
    margin-bottom: 20px;
    text-shadow: 0 0 20px rgba(255, 255, 255, 0.5);
}

.heart-shape {
    width: 60px;
    height: 54px;
    position: relative;
    animation: pulse 2s ease-in-out infinite;
}

.heart-shape:before,
.heart-shape:after {
    content: "";
    width: 30px;
    height: 48px;
    position: absolute;
    left: 30px;
    transform: rotate(-45deg);
    background: var(--white);
    border-radius: 30px 30px 0 0;
    transform-origin: 0 100%;
    box-shadow: 0 0 20px rgba(255, 255, 255, 0.4);
}

.heart-shape:after {
    left: 0;
    transform: rotate(45deg);
    transform-origin: 100% 100%;
}

.success-details {
    max-width: 800px;
    width: 100%;
    animation: fadeInUp 1s ease-out 0.6s both;
}

.message-card {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 20px;
    padding: 30px;
    margin-bottom: 30px;
    text-align: center;
}

.romantic-message,
.concert-details {
    color: var(--white);
    font-size: 1.3rem;
    line-height: 1.6;
    margin-bottom: 15px;
}

.romantic-message {
    font-family: var(--font-romantic);
    font-size: 1.5rem;
}

.fun-facts {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 15px;
    padding: 25px;
    margin-bottom: 30px;
}

.fun-facts h3 {
    color: var(--white);
    font-family: var(--font-romantic);
    font-size: 1.8rem;
    text-align: center;
    margin-bottom: 20px;
}

.fact-list {
    display: grid;
    gap: 15px;
}

.fact-item {
    display: flex;
    align-items: center;
    color: var(--white);
    font-size: 1.1rem;
    padding: 10px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 10px;
    transition: transform 0.3s ease;
}

.fact-item:hover {
    transform: translateX(10px);
}

.fact-icon {
    font-size: 1.5rem;
    margin-right: 15px;
    width: 30px;
    text-align: center;
}

.countdown-section {
    text-align: center;
    margin-bottom: 30px;
    padding: 25px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 15px;
}

.countdown-section h3 {
    color: var(--white);
    font-family: var(--font-romantic);
    font-size: 1.8rem;
    margin-bottom: 20px;
}

.countdown-timer {
    display: flex;
    justify-content: center;
    gap: 20px;
}

.time-unit {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 15px 20px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 10px;
    min-width: 80px;
}

.time-number {
    font-size: 2rem;
    font-weight: bold;
    color: var(--white);
}

.time-label {
    font-size: 0.9rem;
    color: rgba(255, 255, 255, 0.8);
    text-transform: uppercase;
    letter-spacing: 1px;
}

.action-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    justify-content: center;
    margin-bottom: 30px;
}

.btn {
    padding: 12px 24px;
    border: none;
    border-radius: 25px;
    font-family: var(--font-primary);
    font-weight: 600;
    font-size: 1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.btn-primary {
    background: linear-gradient(
        45deg,
        var(--primary-color),
        var(--secondary-color)
    );
    color: var(--white);
    box-shadow: var(--shadow-medium);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: var(--shadow-strong);
}

.btn-secondary {
    background: rgba(255, 255, 255, 0.2);
    color: var(--white);
    border: 1px solid rgba(255, 255, 255, 0.3);
}

.btn-secondary:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: translateY(-2px);
}

.btn-outline {
    background: transparent;
    color: var(--white);
    border: 2px solid var(--white);
}

.btn-outline:hover {
    background: var(--white);
    color: var(--primary-color);
    transform: translateY(-2px);
}

.btn-restart {
    background: linear-gradient(45deg, #ff6b9d, #ff8a80);
    color: var(--white);
    font-size: 0.9rem;
    padding: 10px 20px;
}

.restart-section {
    text-align: center;
    padding-top: 20px;
    border-top: 1px solid rgba(255, 255, 255, 0.2);
}

.restart-text {
    color: rgba(255, 255, 255, 0.8);
    margin-bottom: 15px;
    font-style: italic;
}

.floating-elements {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: -1;
}

.floating-element {
    position: absolute;
    animation: floatUp 4s linear infinite;
    opacity: 0.8;
}

.confetti-canvas {
    position: fixed;
    top: 0;
    left: 0;
    pointer-events: none;
    z-index: 1000;
}

.music-control {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 1001;
}

.music-button {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 15px;
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 25px;
    color: var(--white);
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 0.9rem;
}

.music-button:hover,
.music-button.active {
    background: rgba(255, 255, 255, 0.3);
    transform: scale(1.05);
}

/* Animations */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes heartbeat {
    0%,
    100% {
        transform: scale(1);
    }
    14% {
        transform: scale(1.1);
    }
    28% {
        transform: scale(1);
    }
    42% {
        transform: scale(1.1);
    }
    70% {
        transform: scale(1);
    }
}

@keyframes pulse {
    0%,
    100% {
        transform: scale(1);
        opacity: 1;
    }
    50% {
        transform: scale(1.05);
        opacity: 0.8;
    }
}

@keyframes floatUp {
    0% {
        opacity: 0;
        transform: translateY(100vh) scale(0) rotate(0deg);
    }
    10% {
        opacity: 1;
    }
    90% {
        opacity: 1;
    }
    100% {
        opacity: 0;
        transform: translateY(-20px) scale(1) rotate(360deg);
    }
}

/* Mobile Responsiveness */
@media (max-width: 768px) {
    .success-title {
        font-size: 2.5rem;
    }

    .success-subtitle {
        font-size: 1.2rem;
    }

    .beating-heart {
        font-size: 4rem;
    }

    .romantic-message {
        font-size: 1.2rem;
    }

    .concert-details {
        font-size: 1rem;
    }

    .countdown-timer {
        flex-direction: column;
        gap: 10px;
        align-items: center;
    }

    .time-unit {
        min-width: 60px;
        padding: 10px 15px;
    }

    .time-number {
        font-size: 1.5rem;
    }

    .action-buttons {
        flex-direction: column;
        align-items: center;
    }

    .btn {
        width: 100%;
        max-width: 250px;
        justify-content: center;
    }

    .message-card,
    .fun-facts,
    .countdown-section {
        margin: 0 10px 20px;
        padding: 20px;
    }
}

@media (max-width: 480px) {
    .success-title {
        font-size: 2rem;
        line-height: 1.3;
    }

    .fact-item {
        flex-direction: column;
        text-align: center;
        gap: 5px;
    }

    .fact-icon {
        margin-right: 0;
        margin-bottom: 5px;
    }
}
</style>
