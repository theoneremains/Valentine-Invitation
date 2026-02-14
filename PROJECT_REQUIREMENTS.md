# Project Requirements - Valentine's Day DKTT Concert Invitation

## Overview
This is a Valentine's Day themed web application designed as a romantic invitation to a DKTT Concert. The project creates an interactive and playful experience for the user to respond to a concert invitation.

## Core Features

### Main Question Page
- Display the question: "Benimle DKTT Konserine Gelmek İster misiniz Hanımefendi?"
- Two answer buttons: "Evet" (Yes) and "Hayır" (No)
- Heart-shaped images as decorative elements

### Interactive "No" Button Behavior
- The "No" button moves around the screen when hovered or clicked
- When clicked, it disappears and reappears with different prompts
- Random prompts for "No" button include:
  - "Emin misiniz?"
  - "Gerçekten mi?"
  - "Bir daha düşünür müsünüz?"
  - "Lütfen tekrar düşünün"
  - "Son kararınız mı?"

### Progressive "Yes" Button Enhancement
- Each time "No" is clicked, the "Yes" button gets more loving messages
- Progressive "Yes" button text examples:
  - "Evet"
  - "Tabii ki hayatım"
  - "Buna nasıl hayır diyebilirim?"
  - "Hayır diyemem, çünkü seni seviyorum"
  - "Seninle her yere gelirim aşkım"

### Success Page
- Triggered when "Yes" is clicked
- Display message: "Teşekkürler Hanımefendi! Seni tüm kalbimle seviyorum."
- Heart-shaped image
- Romantic animations and transitions
- Confetti or falling hearts animation

### Technical Requirements
- Built with Vue.js
- Responsive design
- Smooth animations and transitions
- Database integration to store user responses
- Mobile-friendly interface

### Visual Design
- Valentine's Day color scheme (reds, pinks, whites)
- Heart-shaped elements and decorations
- Romantic fonts and typography
- Engaging hover effects and animations
- Particle effects or background animations

## User Flow
1. User lands on main page with the concert invitation question
2. User sees "Evet" and "Hayır" buttons
3. If "Hayır" is clicked:
   - Button moves to new position
   - Shows new prompt
   - "Evet" button gets more romantic text
4. If "Evet" is clicked:
   - Redirect to success page
   - Show thank you message with animations
   - Store response in database
5. Success page displays romantic confirmation with visual effects

## Database Schema
- Store user responses with timestamp
- Track number of "No" clicks before final answer
- Optional: Store IP or session for analytics

## Deployment
- Prepare for GitHub Pages or similar hosting
- Ensure mobile responsiveness
- Optimize for quick loading