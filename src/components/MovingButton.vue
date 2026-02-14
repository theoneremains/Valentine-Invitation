<template>
    <button
        :class="[
            'moving-button',
            { 'is-moving': isMoving, 'is-wiggling': isWiggling },
        ]"
        :style="{
            left: position.x + 'px',
            top: position.y + 'px',
            fontSize: fontSize + 'rem',
        }"
        @click="handleClick"
        @mouseenter="handleMouseEnter"
        @mouseleave="handleMouseLeave"
    >
        <span class="button-text">{{ text }}</span>
        <span class="button-emoji">{{ emoji }}</span>
    </button>
</template>

<script>
import { getRandomPosition } from "../data/responses.js";

export default {
    name: "MovingButton",
    props: {
        text: {
            type: String,
            required: true,
        },
        position: {
            type: Object,
            default: () => ({ x: 0, y: 0 }),
        },
        fontSize: {
            type: Number,
            default: 1.1,
        },
        emoji: {
            type: String,
            default: "😢",
        },
        moveOnHover: {
            type: Boolean,
            default: true,
        },
        wiggleOnHover: {
            type: Boolean,
            default: true,
        },
    },
    emits: ["click", "move", "hover"],
    data() {
        return {
            isMoving: false,
            isWiggling: false,
            buttonWidth: 120,
            buttonHeight: 50,
        };
    },
    methods: {
        handleClick() {
            this.isWiggling = true;

            // Stop wiggling after animation
            setTimeout(() => {
                this.isWiggling = false;
            }, 500);

            // Move to new position
            this.moveButton();

            this.$emit("click", {
                position: this.position,
                text: this.text,
            });
        },

        handleMouseEnter() {
            if (this.moveOnHover) {
                this.moveButton();
            }

            if (this.wiggleOnHover && !this.isMoving) {
                this.isWiggling = true;
                setTimeout(() => {
                    this.isWiggling = false;
                }, 300);
            }

            this.$emit("hover", "enter");
        },

        handleMouseLeave() {
            this.$emit("hover", "leave");
        },

        moveButton() {
            this.isMoving = true;

            // Calculate new position
            const newPosition = this.calculateNewPosition();

            // Emit move event with new position
            this.$emit("move", newPosition);

            // Stop moving animation
            setTimeout(() => {
                this.isMoving = false;
            }, 500);
        },

        calculateNewPosition() {
            const margin = 20;
            const safeWidth = Math.max(300, window.innerWidth);
            const safeHeight = Math.max(200, window.innerHeight);
            const maxX = safeWidth - this.buttonWidth - margin;
            const maxY = safeHeight - this.buttonHeight - margin;

            // Avoid center area (where Yes button might be)
            const centerX = safeWidth / 2;
            const centerY = safeHeight / 2;
            const avoidRadius = 150;

            let newX, newY;
            let attempts = 0;
            const maxAttempts = 10;

            do {
                newX = Math.max(margin, Math.random() * maxX);
                newY = Math.max(margin, Math.random() * maxY);
                attempts++;
            } while (
                attempts < maxAttempts &&
                Math.sqrt(
                    Math.pow(newX - centerX, 2) + Math.pow(newY - centerY, 2),
                ) < avoidRadius
            );

            // If still in center area, move to corners
            if (
                Math.sqrt(
                    Math.pow(newX - centerX, 2) + Math.pow(newY - centerY, 2),
                ) < avoidRadius
            ) {
                const corners = [
                    { x: margin, y: margin },
                    { x: Math.max(margin, maxX), y: margin },
                    { x: margin, y: Math.max(margin, maxY) },
                    { x: Math.max(margin, maxX), y: Math.max(margin, maxY) },
                ];
                const randomCorner =
                    corners[Math.floor(Math.random() * corners.length)];
                newX = randomCorner.x;
                newY = randomCorner.y;
            }

            // Final safeguard to ensure button stays within viewport
            newX = Math.max(
                margin,
                Math.min(newX, safeWidth - this.buttonWidth - margin),
            );
            newY = Math.max(
                margin,
                Math.min(newY, safeHeight - this.buttonHeight - margin),
            );

            return { x: newX, y: newY };
        },

        updateButtonSize() {
            // Get actual button dimensions for better positioning
            this.$nextTick(() => {
                const button = this.$el;
                if (button) {
                    this.buttonWidth = button.offsetWidth || 120;
                    this.buttonHeight = button.offsetHeight || 50;
                }
            });
        },
    },

    mounted() {
        this.updateButtonSize();

        // Update size on window resize
        window.addEventListener("resize", this.updateButtonSize);
    },

    beforeUnmount() {
        window.removeEventListener("resize", this.updateButtonSize);
    },

    watch: {
        text() {
            this.$nextTick(this.updateButtonSize);
        },
    },
};
</script>

<style scoped>
.moving-button {
    position: fixed;
    background: rgba(255, 255, 255, 0.95);
    color: var(--primary-color);
    border: 2px solid var(--primary-color);
    border-radius: 50px;
    padding: 12px 25px;
    font-family: var(--font-primary);
    font-weight: 600;
    cursor: pointer;
    box-shadow: var(--shadow-soft);
    transition: all 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
    backdrop-filter: blur(5px);
    z-index: 1000;
    user-select: none;
    display: flex;
    align-items: center;
    gap: 8px;
    white-space: nowrap;
    transform-origin: center;
}

.moving-button:hover {
    background: var(--primary-color);
    color: var(--white);
    box-shadow: var(--shadow-medium);
    transform: scale(1.05);
}

.moving-button:active {
    transform: scale(0.98);
}

.moving-button.is-moving {
    transition: all 0.8s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.moving-button.is-wiggling {
    animation: wiggle 0.5s ease-in-out;
}

.button-text {
    font-size: inherit;
}

.button-emoji {
    font-size: 1.2em;
    display: inline-block;
    animation: bounce 2s ease-in-out infinite;
}

/* Animations */
@keyframes wiggle {
    0%,
    100% {
        transform: rotate(0deg) scale(1);
    }
    25% {
        transform: rotate(-5deg) scale(1.05);
    }
    50% {
        transform: rotate(5deg) scale(1.1);
    }
    75% {
        transform: rotate(-3deg) scale(1.05);
    }
}

@keyframes bounce {
    0%,
    20%,
    50%,
    80%,
    100% {
        transform: translateY(0) rotate(0deg);
    }
    40% {
        transform: translateY(-4px) rotate(-5deg);
    }
    60% {
        transform: translateY(-2px) rotate(5deg);
    }
}

/* Hover effects */
.moving-button::before {
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

.moving-button:hover::before {
    width: 200px;
    height: 200px;
}

/* Different button states */
.moving-button.desperate {
    border-color: #ff4757;
    color: #ff4757;
    animation: shake 0.3s ease-in-out infinite;
}

.moving-button.pleading {
    border-color: #ffa502;
    color: #ffa502;
}

.moving-button.sad {
    border-color: #70a1ff;
    color: #70a1ff;
    opacity: 0.8;
}

@keyframes shake {
    0%,
    100% {
        transform: translateX(0);
    }
    25% {
        transform: translateX(-2px);
    }
    75% {
        transform: translateX(2px);
    }
}

/* Mobile responsiveness */
@media (max-width: 768px) {
    .moving-button {
        position: fixed;
        z-index: 1000;
        max-width: 200px;
        font-size: 0.9rem;
        padding: 10px 20px;
    }

    .moving-button.is-moving {
        animation: mobileWiggle 0.5s ease-in-out;
    }
}

@keyframes mobileWiggle {
    0%,
    100% {
        transform: scale(1) rotate(0deg);
    }
    25% {
        transform: scale(1.05) rotate(-2deg);
    }
    50% {
        transform: scale(1.1) rotate(2deg);
    }
    75% {
        transform: scale(1.05) rotate(-1deg);
    }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
    .moving-button,
    .moving-button.is-moving,
    .moving-button.is-wiggling {
        animation: none !important;
        transition: opacity 0.2s ease !important;
    }
}

/* Focus styles for keyboard navigation */
.moving-button:focus {
    outline: 3px solid var(--accent-color);
    outline-offset: 2px;
}

.moving-button:focus-visible {
    outline: 3px solid var(--primary-color);
    outline-offset: 2px;
}

/* Special effects */
.moving-button.sparkle::after {
    content: "✨";
    position: absolute;
    top: -10px;
    right: -10px;
    animation: sparkleRotate 1.5s ease-in-out infinite;
}

@keyframes sparkleRotate {
    0%,
    100% {
        transform: rotate(0deg) scale(1);
        opacity: 1;
    }
    50% {
        transform: rotate(180deg) scale(1.2);
        opacity: 0.7;
    }
}
</style>
