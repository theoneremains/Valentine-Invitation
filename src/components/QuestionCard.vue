<template>
    <div class="question-card">
        <!-- Decorative hearts -->
        <div class="decoration-hearts">
            <div class="heart-decoration heart-top-left">💕</div>
            <div class="heart-decoration heart-top-right">💖</div>
            <div class="heart-decoration heart-bottom-left">💗</div>
            <div class="heart-decoration heart-bottom-right">💝</div>
        </div>

        <!-- Main question -->
        <h1 class="main-question">{{ question }}</h1>

        <!-- Subtitle -->
        <p class="subtitle">{{ subtitle }}</p>

        <!-- Fun fact display -->
        <div v-if="funFact" class="fun-fact" :key="funFact">
            {{ funFact }}
        </div>

        <!-- Progress indicator -->
        <div v-if="showProgress" class="progress-section">
            <div class="progress-bar">
                <div
                    class="progress-fill"
                    :style="{ width: progressPercentage + '%' }"
                ></div>
            </div>
            <p class="progress-text">
                Kalbini dinleme oranı: %{{ progressPercentage }}
            </p>
        </div>

        <!-- Button container -->
        <div class="button-container">
            <slot name="buttons"></slot>
        </div>

        <!-- Attempt counter -->
        <div v-if="attemptCount > 0" class="attempt-counter">
            <p class="attempt-text">
                Aman aman neler oluyor! {{ attemptCount }} kez hayır dedin...
                <span class="heart-break">💔</span>
                Kalbimi kırıyorsunuz hanımefendi, lütfen dikkatli olun.
            </p>
            <div class="encouragement-message">
                <p>{{ getEncouragementMessage() }}</p>
            </div>
        </div>

        <!-- Background pattern -->
        <div class="background-pattern"></div>
    </div>
</template>

<script>
export default {
    name: "QuestionCard",
    props: {
        question: {
            type: String,
            required: true,
        },
        subtitle: {
            type: String,
            default: "Bu özel geceyi birlikte geçirmek ister misiniz?",
        },
        funFact: {
            type: String,
            default: "",
        },
        attemptCount: {
            type: Number,
            default: 0,
        },
        showProgress: {
            type: Boolean,
            default: true,
        },
    },
    computed: {
        progressPercentage() {
            // Calculate progress based on attempt count
            // More attempts = higher chance of saying yes
            const maxAttempts = 15;
            const progress = Math.min(
                (this.attemptCount / maxAttempts) * 100,
                95,
            );
            return Math.round(progress);
        },
    },
    methods: {
        getEncouragementMessage() {
            const messages = [
                "Ama hala umudumu kaybetmiyorum 💕",
                "Kalbinizin sesini dinleyin 💖",
                "Aşk her zaman kazanır 💗",
                "Belki bu sefer evet dersiniz? 💝",
                "Sizinle olmayı çok istiyorum 💘",
                "Bu kadar dirençli olmayın 😊",
                "Hayatım, lütfen bir şans verin 💞",
                "Kalbiniz evet diyor, biliyorum 💓",
                "Aşkımıza bir fırsat tanıyın 💜",
                "Siz benim dünyamsınız 🌟",
            ];

            const index = Math.min(this.attemptCount - 1, messages.length - 1);
            return messages[index] || messages[messages.length - 1];
        },
    },
    mounted() {
        // Add entrance animation
        this.$el.classList.add("animate-entrance");
    },
};
</script>

<style scoped>
.question-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(15px);
    border-radius: 25px;
    padding: 40px 30px;
    box-shadow:
        0 20px 40px rgba(255, 107, 157, 0.3),
        0 8px 16px rgba(255, 107, 157, 0.2),
        inset 0 1px 0 rgba(255, 255, 255, 0.4);
    border: 2px solid rgba(255, 255, 255, 0.3);
    position: relative;
    overflow: hidden;
    max-width: 800px;
    width: 100%;
    text-align: center;
    transform: translateY(20px);
    opacity: 0;
    transition: all 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.question-card.animate-entrance {
    transform: translateY(0);
    opacity: 1;
}

.background-pattern {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background:
        radial-gradient(
            circle at 20% 20%,
            rgba(255, 192, 203, 0.1) 0%,
            transparent 50%
        ),
        radial-gradient(
            circle at 80% 80%,
            rgba(255, 182, 193, 0.1) 0%,
            transparent 50%
        ),
        radial-gradient(
            circle at 40% 60%,
            rgba(255, 105, 180, 0.05) 0%,
            transparent 50%
        );
    pointer-events: none;
    animation: patternFloat 8s ease-in-out infinite;
}

@keyframes patternFloat {
    0%,
    100% {
        transform: translate(0, 0) scale(1);
    }
    50% {
        transform: translate(5px, -5px) scale(1.02);
    }
}

.decoration-hearts {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
}

.heart-decoration {
    position: absolute;
    font-size: 1.5rem;
    opacity: 0.6;
    animation: floatHeart 3s ease-in-out infinite;
}

.heart-top-left {
    top: 15px;
    left: 20px;
    animation-delay: 0s;
}

.heart-top-right {
    top: 15px;
    right: 20px;
    animation-delay: 0.5s;
}

.heart-bottom-left {
    bottom: 15px;
    left: 20px;
    animation-delay: 1s;
}

.heart-bottom-right {
    bottom: 15px;
    right: 20px;
    animation-delay: 1.5s;
}

@keyframes floatHeart {
    0%,
    100% {
        transform: translateY(0px) rotate(0deg);
    }
    50% {
        transform: translateY(-8px) rotate(5deg);
    }
}

.main-question {
    font-family: var(--font-romantic);
    font-size: 2.5rem;
    font-weight: 700;
    color: var(--primary-color);
    margin-bottom: 20px;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
    line-height: 1.3;
    position: relative;
    z-index: 2;
}

.subtitle {
    font-size: 1.2rem;
    color: var(--dark);
    margin-bottom: 30px;
    opacity: 0.8;
    font-weight: 500;
    position: relative;
    z-index: 2;
}

.fun-fact {
    background: linear-gradient(
        135deg,
        rgba(255, 107, 157, 0.1),
        rgba(255, 138, 128, 0.1)
    );
    border: 1px solid rgba(255, 107, 157, 0.2);
    border-radius: 15px;
    padding: 15px 20px;
    margin: 20px 0;
    color: var(--primary-color);
    font-style: italic;
    font-weight: 500;
    position: relative;
    z-index: 2;
    animation: slideInFact 0.5s ease-out;
}

@keyframes slideInFact {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.progress-section {
    margin: 25px 0;
    position: relative;
    z-index: 2;
}

.progress-bar {
    width: 100%;
    height: 8px;
    background: rgba(255, 107, 157, 0.2);
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 10px;
}

.progress-fill {
    height: 100%;
    background: linear-gradient(
        90deg,
        var(--primary-color),
        var(--secondary-color)
    );
    border-radius: 10px;
    transition: width 1s ease-out;
    box-shadow: 0 0 10px rgba(255, 107, 157, 0.5);
}

.progress-text {
    font-size: 0.9rem;
    color: var(--primary-color);
    font-weight: 600;
    margin: 0;
}

.button-container {
    display: flex;
    gap: 20px;
    justify-content: center;
    align-items: center;
    flex-wrap: wrap;
    position: relative;
    min-height: 80px;
    z-index: 2;
    margin: 30px 0;
}

.attempt-counter {
    margin-top: 20px;
    padding: 15px;
    background: rgba(255, 107, 157, 0.05);
    border-radius: 15px;
    border-left: 4px solid var(--primary-color);
    position: relative;
    z-index: 2;
    animation: shakeIn 0.5s ease-out;
}

@keyframes shakeIn {
    0% {
        transform: translateX(-10px);
        opacity: 0;
    }
    50% {
        transform: translateX(5px);
    }
    100% {
        transform: translateX(0);
        opacity: 1;
    }
}

.attempt-text {
    color: var(--primary-color);
    font-weight: 600;
    margin: 0 0 10px 0;
    font-size: 1.1rem;
}

.heart-break {
    display: inline-block;
    animation: heartBreak 0.5s ease-in-out;
}

@keyframes heartBreak {
    0% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.2) rotate(-5deg);
    }
    100% {
        transform: scale(1) rotate(0deg);
    }
}

.encouragement-message {
    background: rgba(255, 255, 255, 0.7);
    border-radius: 10px;
    padding: 10px;
    margin-top: 10px;
}

.encouragement-message p {
    color: var(--primary-color);
    font-style: italic;
    margin: 0;
    font-size: 1rem;
}

/* Hover effects for the entire card */
.question-card:hover {
    transform: translateY(-2px);
    box-shadow:
        0 25px 50px rgba(255, 107, 157, 0.4),
        0 10px 20px rgba(255, 107, 157, 0.3),
        inset 0 1px 0 rgba(255, 255, 255, 0.5);
}

.question-card:hover .heart-decoration {
    animation-duration: 2s;
    opacity: 0.8;
}

/* Mobile responsiveness */
@media (max-width: 768px) {
    .question-card {
        padding: 30px 20px;
        margin: 0 10px;
        border-radius: 20px;
    }

    .main-question {
        font-size: 2rem;
        margin-bottom: 15px;
    }

    .subtitle {
        font-size: 1rem;
        margin-bottom: 25px;
    }

    .button-container {
        flex-direction: column;
        gap: 15px;
        min-height: 120px;
    }

    .heart-decoration {
        font-size: 1.2rem;
    }
}

@media (max-width: 480px) {
    .question-card {
        padding: 25px 15px;
    }

    .main-question {
        font-size: 1.8rem;
        line-height: 1.4;
    }

    .subtitle {
        font-size: 0.95rem;
    }

    .fun-fact {
        padding: 12px 15px;
        font-size: 0.9rem;
    }

    .attempt-text {
        font-size: 1rem;
    }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
    .question-card,
    .heart-decoration,
    .background-pattern,
    .progress-fill,
    .fun-fact,
    .attempt-counter {
        animation: none !important;
        transition: opacity 0.2s ease !important;
    }
}

/* High contrast mode */
@media (prefers-contrast: high) {
    .question-card {
        background: #ffffff;
        border: 3px solid #d63384;
    }

    .main-question {
        color: #d63384;
        text-shadow: none;
    }

    .subtitle {
        color: #000000;
    }
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    .question-card {
        background: rgba(45, 55, 72, 0.95);
        border-color: rgba(255, 107, 157, 0.5);
    }

    .subtitle {
        color: rgba(255, 255, 255, 0.9);
    }

    .encouragement-message {
        background: rgba(255, 255, 255, 0.1);
    }
}
</style>
