#!/bin/bash

# Valentine's Day DKTT Concert Invitation - Setup Script
# This script will help you set up and run the romantic Vue.js application

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Heart emoji for romantic output
HEART="💖"
SPARKLE="✨"

echo -e "${PURPLE}${HEART}${HEART}${HEART} Valentine's Day Concert Invitation Setup ${HEART}${HEART}${HEART}${NC}"
echo -e "${CYAN}Setting up your romantic Vue.js application...${NC}"
echo ""

# Function to print colored output
print_step() {
    echo -e "${BLUE}${SPARKLE} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${HEART} $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if Node.js is installed
check_node() {
    print_step "Checking Node.js installation..."

    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed!"
        echo "Please install Node.js from https://nodejs.org/"
        echo "Recommended version: Node.js 18 or higher"
        exit 1
    fi

    NODE_VERSION=$(node --version)
    print_success "Node.js found: $NODE_VERSION"
}

# Check if npm is installed
check_npm() {
    print_step "Checking npm installation..."

    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed!"
        echo "Please install npm (usually comes with Node.js)"
        exit 1
    fi

    NPM_VERSION=$(npm --version)
    print_success "npm found: v$NPM_VERSION"
}

# Install dependencies
install_dependencies() {
    print_step "Installing project dependencies..."

    if [ ! -f "package.json" ]; then
        print_error "package.json not found! Are you in the right directory?"
        exit 1
    fi

    npm install

    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully!"
    else
        print_error "Failed to install dependencies!"
        exit 1
    fi
}

# Create environment file (optional)
create_env_file() {
    print_step "Creating environment configuration..."

    if [ ! -f ".env" ]; then
        cat > .env << EOF
# Valentine's Day Concert Invitation - Environment Variables
VITE_APP_TITLE=DKTT Concert Invitation
VITE_CONCERT_DATE=2024-02-14T20:00:00
VITE_ENABLE_MUSIC=false
VITE_DEBUG_MODE=false
EOF
        print_success "Environment file created (.env)"
    else
        print_warning "Environment file already exists"
    fi
}

# Check Git repository
setup_git() {
    print_step "Setting up Git repository..."

    if [ ! -d ".git" ]; then
        git init
        print_success "Git repository initialized"
    else
        print_warning "Git repository already exists"
    fi

    # Add all files to git
    git add .

    # Check if there are changes to commit
    if ! git diff --cached --quiet; then
        git commit -m "💖 Initial commit: Valentine's Day Concert Invitation

- Created romantic Vue.js application
- Added interactive moving 'No' button
- Implemented progressive 'Yes' button enhancement
- Added floating hearts and sparkle effects
- Created success page with celebration animations
- Added responsive design for mobile devices
- Implemented localStorage for user response tracking

Ready to share love! 💕"
        print_success "Initial commit created"
    else
        print_warning "No changes to commit"
    fi
}

# Build project for production
build_project() {
    print_step "Building project for production..."

    npm run build

    if [ $? -eq 0 ]; then
        print_success "Production build completed successfully!"
        print_success "Built files are in the 'dist' directory"
    else
        print_error "Build failed!"
        exit 1
    fi
}

# Function to start development server
start_dev_server() {
    print_step "Starting development server..."
    print_success "Opening http://localhost:3000 in your browser..."
    print_success "Press Ctrl+C to stop the server"
    echo ""
    echo -e "${PURPLE}${HEART} Enjoy your romantic application! ${HEART}${NC}"
    echo ""

    npm run dev
}

# Function to show help
show_help() {
    echo -e "${CYAN}Valentine's Day Concert Invitation Setup Script${NC}"
    echo ""
    echo "Usage: ./setup.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  install    Install dependencies and set up the project"
    echo "  dev        Start development server"
    echo "  build      Build for production"
    echo "  deploy     Build and prepare for deployment"
    echo "  clean      Clean node_modules and reinstall"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./setup.sh install    # Full setup"
    echo "  ./setup.sh dev        # Start development"
    echo "  ./setup.sh build      # Production build"
    echo ""
}

# Clean installation
clean_install() {
    print_step "Cleaning previous installation..."

    if [ -d "node_modules" ]; then
        rm -rf node_modules
        print_success "node_modules removed"
    fi

    if [ -f "package-lock.json" ]; then
        rm package-lock.json
        print_success "package-lock.json removed"
    fi

    install_dependencies
}

# Deploy preparation
prepare_deploy() {
    print_step "Preparing for deployment..."

    # Build the project
    build_project

    # Create deployment info
    cat > dist/deploy-info.txt << EOF
Valentine's Day Concert Invitation
Deployment Date: $(date)
Git Commit: $(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
Node Version: $(node --version)
Build Command: npm run build

💖 Ready to deploy your romantic invitation! 💖

Deployment Instructions:
1. Upload the contents of this 'dist' folder to your web server
2. Ensure your server serves index.html for all routes (SPA mode)
3. Configure HTTPS for better user experience
4. Test the application on different devices

Happy sharing! 💕
EOF

    print_success "Deployment package ready in 'dist' directory"
    print_success "See dist/deploy-info.txt for deployment instructions"
}

# Main script logic
main() {
    case "${1:-install}" in
        "install")
            check_node
            check_npm
            install_dependencies
            create_env_file
            setup_git
            echo ""
            print_success "Setup completed successfully! ${HEART}"
            echo ""
            echo -e "${CYAN}Next steps:${NC}"
            echo "1. Run './setup.sh dev' to start development server"
            echo "2. Run './setup.sh build' to build for production"
            echo "3. Customize your concert date in .env file"
            echo ""
            echo -e "${PURPLE}${HEART} Your romantic invitation is ready to share! ${HEART}${NC}"
            ;;
        "dev")
            check_node
            check_npm
            if [ ! -d "node_modules" ]; then
                print_warning "Dependencies not found. Installing..."
                install_dependencies
            fi
            start_dev_server
            ;;
        "build")
            check_node
            check_npm
            if [ ! -d "node_modules" ]; then
                print_error "Dependencies not found. Run './setup.sh install' first."
                exit 1
            fi
            build_project
            ;;
        "deploy")
            check_node
            check_npm
            if [ ! -d "node_modules" ]; then
                print_error "Dependencies not found. Run './setup.sh install' first."
                exit 1
            fi
            prepare_deploy
            ;;
        "clean")
            clean_install
            print_success "Clean installation completed!"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
