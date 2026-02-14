<template>
    <div class="valentine-container">
        <!-- Question Page -->
        <div v-if="!showSuccess">
            <QuestionCard
                :question="mainQuestion"
                :subtitle="subtitle"
                :fun-fact="currentFunFact"
                :attempt-count="noClickCount"
                :show-progress="true"
            >
                <template #buttons>
                    <!-- Yes Button -->
                    <button
                        class="btn btn-yes"
                        @click="handleYesClick"
                        :style="{ fontSize: yesButtonFontSize + 'rem' }"
                    >
                        {{ currentYesText }}
                    </button>
                </template>
            </QuestionCard>
        </div>

        <!-- Moving No Button - Floats on entire page -->
        <MovingButton
            v-if="showNoButton && !showSuccess"
            :text="currentNoText"
            :position="noButtonPosition"
            :font-size="1.1"
            :emoji="getNoButtonEmoji()"
            :move-on-hover="true"
            :wiggle-on-hover="true"
            @click="handleNoClick"
            @move="updateNoButtonPosition"
            @hover="handleNoButtonHover"
        />

        <!-- Success Page -->
        <SuccessPage
            v-if="showSuccess"
            :no-click-count="noClickCount"
            :final-yes-text="currentYesText"
            :show-countdown="true"
            :concert-date="concertDate"
            :show-music-control="false"
            @restart="restartExperience"
            @save-calendar="handleSaveCalendar"
            @share="handleShare"
            @download="handleDownload"
        />

        <!-- Floating Hearts -->
        <div
            v-for="heart in floatingHearts"
            :key="heart.id"
            class="floating-heart"
            :style="{
                left: heart.x + 'px',
                top: heart.y + 'px',
                animationDelay: heart.delay + 'ms',
            }"
        >
            {{ heart.symbol }}
        </div>

        <!-- Prompt Notification (shows when No button is clicked) -->
        <div
            v-if="currentPrompt"
            class="prompt-notification"
            @click="currentPrompt = ''"
        >
            {{ currentPrompt }}
        </div>

        <!-- Compliment Box -->
        <div
            v-if="currentCompliment"
            class="compliment-box"
            @click="currentCompliment = ''"
        >
            {{ currentCompliment }}
        </div>

        <!-- Sparkles -->
        <div
            v-for="sparkle in sparkles"
            :key="sparkle.id"
            class="sparkle"
            :style="{
                left: sparkle.x + 'px',
                top: sparkle.y + 'px',
            }"
        ></div>

        <!-- Easter Egg Message -->
        <div
            v-if="showEasterEgg"
            class="easter-egg"
            @click="showEasterEgg = false"
        >
            🎉 Tebrikler! {{ noClickCount }} kez hayır demeye rağmen sonunda
            evet dediniz! Bu kararlılığınızı seviyorum! 💕
        </div>
    </div>
</template>

<script>
import QuestionCard from "./components/QuestionCard.vue";
import MovingButton from "./components/MovingButton.vue";
import SuccessPage from "./components/SuccessPage.vue";
import {
    noPrompts,
    yesTexts,
    successMessages,
    compliments,
    funFacts,
    getRandomPosition,
} from "./data/responses.js";

export default {
    name: "ValentineApp",
    components: {
        QuestionCard,
        MovingButton,
        SuccessPage,
    },
    data() {
        return {
            // Main content
            mainQuestion:
                "Benimle DKTT Konserine Gelmek İster misiniz Hanımefendi?",
            subtitle: "Bu özel geceyi birlikte geçirmek ister misiniz?",
            concertDate: "2026-02-14T18:45:00.000Z", // 21:45 GMT+3 = 18:45 UTC

            // State management
            showSuccess: false,
            showNoButton: true,
            showEasterEgg: false,

            // Button texts and positions
            currentYesText: yesTexts[0],
            currentNoText: noPrompts[0],
            yesTextIndex: 0,
            noTextIndex: 0,

            // Button styling and position
            yesButtonFontSize: 1.1,
            noButtonPosition: { x: 200, y: 0 },

            // Counters
            noClickCount: 0,
            totalInteractions: 0,
            consecutiveNoClicks: 0,

            // Visual effects
            floatingHearts: [],
            sparkles: [],
            currentCompliment: "",
            currentFunFact: "",
            currentPrompt: "", // For showing No button prompts

            // Data arrays
            noPrompts,
            yesTexts,
            successMessages,
            compliments,
            funFacts,

            // Timers
            complimentTimer: null,
            funFactTimer: null,
            heartTimer: null,
        };
    },

    mounted() {
        // Wait for DOM to be ready before positioning button
        this.$nextTick(() => {
            this.initializePosition();
        });
        this.startComplimentRotation();
        this.startFunFactRotation();
        this.startHeartAnimation();
        this.loadUserData();
        this.addKeyboardListeners();
    },

    beforeUnmount() {
        this.clearTimers();
        this.removeKeyboardListeners();
    },

    methods: {
        initializePosition() {
            // Set initial position for No button - place it in a visible spot
            // Use nextTick to ensure DOM is ready
            this.$nextTick(() => {
                const buttonWidth = 120;
                const buttonHeight = 50;
                const margin = 20;

                this.noButtonPosition = {
                    x: Math.max(
                        margin,
                        window.innerWidth - buttonWidth - margin - 100,
                    ),
                    y: Math.max(
                        margin,
                        window.innerHeight / 2 - buttonHeight / 2,
                    ),
                };
            });
        },

        handleYesClick() {
            // Show easter egg if many no clicks
            if (this.noClickCount > 8) {
                this.showEasterEgg = true;
            }

            // Create celebration effects
            this.createSparkles();
            this.createFloatingHearts(15, "💖");
            this.createConfettiEffect();

            // Store user response
            this.saveUserResponse(true);

            // Show success page with delay for effects
            setTimeout(() => {
                this.showSuccess = true;
                this.playCelebrationSound();
            }, 800);
        },

        handleNoClick(data) {
            this.noClickCount++;
            this.totalInteractions++;
            this.consecutiveNoClicks++;

            // Update button texts
            this.updateNoText();
            this.updateYesText();

            // Show the prompt notification
            this.showPromptNotification();

            // Create sad hearts
            this.createFloatingHearts(3, this.getSadEmoji());

            // Show compliment to cheer up
            setTimeout(() => {
                this.showRandomCompliment();
            }, 2000);

            // Enhance yes button appeal
            this.enhanceYesButton();

            // Store interaction
            this.saveInteraction();

            // Special effects for persistence
            if (this.noClickCount === 5) {
                this.showSpecialMessage("Gerçekten bu kadar kararlı mısın? 💔");
            } else if (this.noClickCount === 10) {
                this.showSpecialMessage(
                    "Kalbimi parçalıyorsunuz! 😢 Ama seni sevmeyi bırakmıyorum! 💕",
                );
            } else if (this.noClickCount === 15) {
                this.showSpecialMessage(
                    "Bu kararlılığın bile seni daha çok sevmeme sebep oluyor! 💖",
                );
            }
        },

        updateNoButtonPosition(newPosition) {
            this.noButtonPosition = newPosition;
        },

        handleNoButtonHover(type) {
            if (type === "enter") {
                // Add some playful interaction
                this.createFloatingHearts(1, "😅");
            }
        },

        updateNoText() {
            this.noTextIndex = (this.noTextIndex + 1) % this.noPrompts.length;
            this.currentNoText = this.noPrompts[this.noTextIndex];
        },

        updateYesText() {
            if (this.yesTextIndex < this.yesTexts.length - 1) {
                this.yesTextIndex++;
                this.currentYesText = this.yesTexts[this.yesTextIndex];
            }
        },

        enhanceYesButton() {
            // Gradually increase font size
            this.yesButtonFontSize = Math.min(
                1.8,
                this.yesButtonFontSize + 0.03,
            );
        },

        getNoButtonEmoji() {
            if (this.noClickCount > 10) return "😭";
            if (this.noClickCount > 5) return "😢";
            if (this.noClickCount > 2) return "😔";
            return "😅";
        },

        getSadEmoji() {
            const sadEmojis = ["💔", "😢", "😭", "🥺", "😔"];
            return sadEmojis[Math.floor(Math.random() * sadEmojis.length)];
        },

        createFloatingHearts(count = 5, symbol = "💖") {
            for (let i = 0; i < count; i++) {
                const heart = {
                    id: Date.now() + Math.random(),
                    x: Math.random() * window.innerWidth,
                    y: window.innerHeight,
                    symbol: symbol,
                    delay: i * 200,
                };

                this.floatingHearts.push(heart);

                // Remove heart after animation
                setTimeout(() => {
                    this.floatingHearts = this.floatingHearts.filter(
                        (h) => h.id !== heart.id,
                    );
                }, 4000 + heart.delay);
            }
        },

        createSparkles() {
            for (let i = 0; i < 30; i++) {
                const sparkle = {
                    id: Date.now() + Math.random(),
                    x: Math.random() * window.innerWidth,
                    y: Math.random() * window.innerHeight,
                };

                this.sparkles.push(sparkle);

                setTimeout(() => {
                    this.sparkles = this.sparkles.filter(
                        (s) => s.id !== sparkle.id,
                    );
                }, 1500);
            }
        },

        createConfettiEffect() {
            // Create multiple bursts of confetti
            for (let i = 0; i < 5; i++) {
                setTimeout(() => {
                    this.createSparkles();
                }, i * 200);
            }
        },

        showRandomCompliment() {
            const randomCompliment =
                this.compliments[
                    Math.floor(Math.random() * this.compliments.length)
                ];
            this.currentCompliment = randomCompliment;

            // Auto-hide after 4 seconds
            setTimeout(() => {
                this.currentCompliment = "";
            }, 4000);
        },

        showSpecialMessage(message) {
            this.currentCompliment = message;

            setTimeout(() => {
                this.currentCompliment = "";
            }, 5000);
        },

        showPromptNotification() {
            // Show the current no prompt as a notification
            this.currentPrompt = `💔 "${this.currentNoText}"`;

            // Auto-hide after 3 seconds
            setTimeout(() => {
                this.currentPrompt = "";
            }, 3000);
        },

        startComplimentRotation() {
            this.complimentTimer = setInterval(() => {
                if (!this.currentCompliment && !this.showSuccess) {
                    this.showRandomCompliment();
                }
            }, 12000); // Show compliment every 12 seconds
        },

        startFunFactRotation() {
            this.funFactTimer = setInterval(() => {
                if (!this.showSuccess) {
                    const randomFact =
                        this.funFacts[
                            Math.floor(Math.random() * this.funFacts.length)
                        ];
                    this.currentFunFact = randomFact;

                    // Hide after 5 seconds
                    setTimeout(() => {
                        this.currentFunFact = "";
                    }, 5000);
                }
            }, 15000); // Show fun fact every 15 seconds
        },

        startHeartAnimation() {
            this.heartTimer = setInterval(() => {
                if (!this.showSuccess) {
                    this.createFloatingHearts(2);
                }
            }, 6000); // Create hearts every 6 seconds
        },

        clearTimers() {
            if (this.complimentTimer) clearInterval(this.complimentTimer);
            if (this.funFactTimer) clearInterval(this.funFactTimer);
            if (this.heartTimer) clearInterval(this.heartTimer);
        },

        saveUserResponse(accepted) {
            const response = {
                accepted,
                noClickCount: this.noClickCount,
                totalInteractions: this.totalInteractions,
                timestamp: new Date().toISOString(),
                finalYesText: this.currentYesText,
                finalNoText: this.currentNoText,
                sessionDuration: Date.now() - this.sessionStartTime,
            };

            // Save to localStorage
            localStorage.setItem(
                "valentine_response",
                JSON.stringify(response),
            );

            // Here you could also send to a database
            // this.sendToDatabase(response)

            console.log("💕 User response saved:", response);
        },

        saveInteraction() {
            const interactions = JSON.parse(
                localStorage.getItem("valentine_interactions") || "[]",
            );
            interactions.push({
                type: "no_click",
                timestamp: new Date().toISOString(),
                noText: this.currentNoText,
                yesText: this.currentYesText,
                clickCount: this.noClickCount,
                position: { ...this.noButtonPosition },
            });

            localStorage.setItem(
                "valentine_interactions",
                JSON.stringify(interactions),
            );
        },

        loadUserData() {
            this.sessionStartTime = Date.now();

            const savedResponse = localStorage.getItem("valentine_response");
            if (savedResponse) {
                const data = JSON.parse(savedResponse);
                console.log("💖 Previous response found:", data);
            }

            const savedInteractions = localStorage.getItem(
                "valentine_interactions",
            );
            if (savedInteractions) {
                const interactions = JSON.parse(savedInteractions);
                console.log(
                    `📊 Total previous interactions: ${interactions.length}`,
                );
            }
        },

        restartExperience() {
            // Reset all state
            this.showSuccess = false;
            this.showNoButton = true;
            this.showEasterEgg = false;
            this.noClickCount = 0;
            this.totalInteractions = 0;
            this.consecutiveNoClicks = 0;
            this.yesTextIndex = 0;
            this.noTextIndex = 0;
            this.currentYesText = this.yesTexts[0];
            this.currentNoText = this.noPrompts[0];
            this.yesButtonFontSize = 1.1;
            this.currentCompliment = "";
            this.currentFunFact = "";
            this.currentPrompt = "";
            this.floatingHearts = [];
            this.sparkles = [];

            // Reset position
            this.initializePosition();

            // Restart timers
            this.clearTimers();
            this.startComplimentRotation();
            this.startFunFactRotation();
            this.startHeartAnimation();

            // Create celebration for restart
            this.createFloatingHearts(5, "🔄");
        },

        handleSaveCalendar(event) {
            console.log("📅 Calendar event created:", event);
        },

        handleShare() {
            console.log("💕 Experience shared");
        },

        handleDownload() {
            console.log("🎁 Memento downloaded");
        },

        playCelebrationSound() {
            // Optional: Play sound effect if audio file is available
            try {
                const audio = new Audio("/celebration.mp3");
                audio.volume = 0.2;
                audio.play().catch(() => {
                    // Ignore audio errors gracefully
                });
            } catch (error) {
                // Ignore audio errors
            }
        },

        addKeyboardListeners() {
            document.addEventListener("keydown", this.handleKeyPress);
        },

        removeKeyboardListeners() {
            document.removeEventListener("keydown", this.handleKeyPress);
        },

        handleKeyPress(e) {
            // Easter egg: Press 'Y' for instant yes
            if (e.key.toLowerCase() === "y" && !this.showSuccess) {
                this.handleYesClick();
            }

            // Easter egg: Press 'H' for heart shower
            if (e.key.toLowerCase() === "h") {
                for (let i = 0; i < 15; i++) {
                    setTimeout(() => this.createFloatingHearts(1), i * 100);
                }
            }

            // Easter egg: Press 'L' for love message
            if (e.key.toLowerCase() === "l") {
                this.showSpecialMessage(
                    "💕 Seni çok seviyorum! Bu tuşa basman bile kalbimi hızlandırıyor! 💖",
                );
            }
        },
    },
};
</script>

<style scoped>
.valentine-container {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    position: relative;
}

/* Yes Button Enhanced Styles */
.btn-yes {
    background: linear-gradient(
        45deg,
        var(--primary-color),
        var(--secondary-color)
    );
    color: var(--white);
    border: none;
    border-radius: 50px;
    padding: 15px 30px;
    font-family: var(--font-primary);
    font-weight: 600;
    cursor: pointer;
    box-shadow: var(--shadow-medium);
    transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    position: relative;
    overflow: hidden;
    z-index: 5;
    animation: pulse 2s ease-in-out infinite;
}

.btn-yes::before {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    background: rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    transition: all 0.3s ease;
    transform: translate(-50%, -50%);
    z-index: -1;
}

.btn-yes:hover::before {
    width: 300px;
    height: 300px;
}

.btn-yes:hover {
    transform: translateY(-3px) scale(1.05);
    box-shadow: var(--shadow-strong);
    animation: heartbeat 0.6s ease-in-out infinite;
}

.btn-yes:active {
    transform: translateY(-1px) scale(1.02);
}

/* Floating Hearts */
.floating-heart {
    position: fixed;
    color: rgba(255, 255, 255, 0.9);
    font-size: 1.8rem;
    pointer-events: none;
    animation: floatUp 4s ease-out forwards;
    z-index: 1000;
    text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
}

@keyframes floatUp {
    0% {
        opacity: 1;
        transform: translateY(0) scale(1) rotate(0deg);
    }
    100% {
        opacity: 0;
        transform: translateY(-300px) scale(0.3) rotate(180deg);
    }
}

/* Prompt Notification */
.prompt-notification {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: rgba(255, 107, 157, 0.95);
    color: var(--white);
    padding: 20px 30px;
    border-radius: 20px;
    font-family: var(--font-romantic);
    font-size: 1.3rem;
    font-weight: 600;
    box-shadow: var(--shadow-strong);
    animation: bounceIn 0.6s ease-out;
    z-index: 2000;
    max-width: 350px;
    text-align: center;
    cursor: pointer;
    border: 3px solid rgba(255, 255, 255, 0.5);
}

.prompt-notification:hover {
    transform: translate(-50%, -50%) scale(1.02);
}

/* Compliment Box */
.compliment-box {
    position: fixed;
    top: 20px;
    right: 20px;
    background: rgba(255, 255, 255, 0.95);
    color: var(--primary-color);
    padding: 15px 20px;
    border-radius: 15px;
    font-family: var(--font-romantic);
    font-size: 1.1rem;
    font-weight: 600;
    box-shadow: var(--shadow-medium);
    animation: slideInRight 0.5s ease-out;
    z-index: 1000;
    max-width: 280px;
    cursor: pointer;
    border: 2px solid rgba(255, 107, 157, 0.3);
}

.compliment-box:hover {
    transform: scale(1.02);
    box-shadow: var(--shadow-strong);
}

/* Easter Egg Message */
.easter-egg {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: linear-gradient(
        135deg,
        var(--primary-color),
        var(--secondary-color)
    );
    color: var(--white);
    padding: 20px 30px;
    border-radius: 20px;
    font-size: 1.2rem;
    font-weight: 600;
    box-shadow: var(--shadow-strong);
    animation: bounceIn 0.6s ease-out;
    z-index: 2000;
    max-width: 400px;
    text-align: center;
    cursor: pointer;
}

@keyframes bounceIn {
    0% {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.3);
    }
    50% {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1.05);
    }
    100% {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1);
    }
}

/* Sparkles */
.sparkle {
    position: fixed;
    pointer-events: none;
    width: 8px;
    height: 8px;
    background: radial-gradient(circle, var(--white), var(--accent-color));
    border-radius: 50%;
    animation: sparkle 1.5s ease-out forwards;
    z-index: 1001;
}

@keyframes sparkle {
    0% {
        opacity: 1;
        transform: scale(0) rotate(0deg);
    }
    50% {
        opacity: 1;
        transform: scale(1) rotate(180deg);
    }
    100% {
        opacity: 0;
        transform: scale(0) rotate(360deg);
    }
}

/* Animations */
@keyframes slideInRight {
    from {
        opacity: 0;
        transform: translateX(100px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes pulse {
    0%,
    100% {
        transform: scale(1);
        box-shadow: var(--shadow-medium);
    }
    50% {
        transform: scale(1.02);
        box-shadow: var(--shadow-strong);
    }
}

@keyframes heartbeat {
    0%,
    100% {
        transform: translateY(-3px) scale(1.05);
    }
    14% {
        transform: translateY(-5px) scale(1.08);
    }
    28% {
        transform: translateY(-3px) scale(1.05);
    }
    42% {
        transform: translateY(-5px) scale(1.08);
    }
    70% {
        transform: translateY(-3px) scale(1.05);
    }
}

/* Mobile Responsiveness */
@media (max-width: 768px) {
    .valentine-container {
        padding: 10px;
    }

    .prompt-notification {
        max-width: 90%;
        padding: 15px 20px;
        font-size: 1.1rem;
    }

    .compliment-box {
        top: 10px;
        right: 10px;
        left: 10px;
        max-width: none;
        font-size: 1rem;
    }

    .easter-egg {
        max-width: 90%;
        padding: 15px 20px;
        font-size: 1.1rem;
    }

    .btn-yes {
        font-size: 1rem;
        padding: 12px 25px;
    }
}

@media (max-width: 480px) {
    .floating-heart {
        font-size: 1.5rem;
    }

    .prompt-notification {
        font-size: 1rem;
        padding: 12px 18px;
    }

    .compliment-box {
        font-size: 0.9rem;
        padding: 12px 15px;
    }

    .easter-egg {
        font-size: 1rem;
        padding: 12px 18px;
    }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
    .btn-yes,
    .floating-heart,
    .compliment-box,
    .sparkle,
    .easter-egg {
        animation: none !important;
    }

    .btn-yes:hover {
        animation: none !important;
        transform: scale(1.02) !important;
    }
}

/* Focus states for keyboard navigation */
.btn-yes:focus {
    outline: 3px solid var(--accent-color);
    outline-offset: 2px;
}

.btn-yes:focus-visible {
    outline: 3px solid var(--white);
    outline-offset: 2px;
}
</style>
