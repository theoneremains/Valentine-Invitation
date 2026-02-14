#!/bin/bash

# 🚀 Valentine's Day DKTT Concert Invitation - Deploy Script
# This script helps deploy your romantic app to GitHub Pages

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
ROCKET="🚀"

echo -e "${PURPLE}${HEART}${HEART}${HEART} Valentine's Day Concert Invitation Deploy ${HEART}${HEART}${HEART}${NC}"
echo -e "${CYAN}Deploying your romantic Vue.js application to GitHub Pages...${NC}"
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

# Check if git is initialized
check_git() {
    if [ ! -d ".git" ]; then
        print_step "Initializing Git repository..."
        git init
        print_success "Git repository initialized"
    else
        print_success "Git repository already exists"
    fi
}

# Get repository URL
get_repo_url() {
    if git remote get-url origin >/dev/null 2>&1; then
        REPO_URL=$(git remote get-url origin)
        print_success "Repository URL found: $REPO_URL"
    else
        echo ""
        print_warning "No remote repository found!"
        echo ""
        echo -e "${CYAN}Please create a GitHub repository and provide the URL:${NC}"
        echo "1. Go to https://github.com/new"
        echo "2. Create a new repository (e.g., 'Valentine-DKTT-Concert-Invitation')"
        echo "3. Copy the repository URL"
        echo ""
        read -p "Enter your GitHub repository URL: " REPO_URL

        if [ -z "$REPO_URL" ]; then
            print_error "Repository URL is required!"
            exit 1
        fi

        git remote add origin "$REPO_URL"
        print_success "Remote repository added: $REPO_URL"
    fi
}

# Extract repository name from URL
get_repo_name() {
    REPO_NAME=$(basename "$REPO_URL" .git)
    print_success "Repository name: $REPO_NAME"

    # Update Vite config with correct base path
    print_step "Updating Vite configuration for GitHub Pages..."
    sed -i.bak "s|/Valentine-Invitation/|/$REPO_NAME/|g" vite.config.js
    if [ $? -eq 0 ]; then
        print_success "Vite config updated for repository: $REPO_NAME"
        rm -f vite.config.js.bak
    else
        print_warning "Could not update Vite config automatically"
    fi
}

# Build the project
build_project() {
    print_step "Building the project for production..."

    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed! Please install Node.js and npm"
        exit 1
    fi

    npm run build

    if [ $? -eq 0 ]; then
        print_success "Project built successfully!"
    else
        print_error "Build failed!"
        exit 1
    fi
}

# Commit and push changes
deploy_to_github() {
    print_step "Committing changes..."

    git add .

    if git diff --cached --quiet; then
        print_warning "No changes to commit"
    else
        COMMIT_MSG="${ROCKET} Deploy romantic invitation $(date '+%Y-%m-%d %H:%M:%S')"
        git commit -m "$COMMIT_MSG"
        print_success "Changes committed"
    fi

    print_step "Pushing to GitHub..."

    # Check if main branch exists
    if git show-ref --verify --quiet refs/heads/main; then
        BRANCH="main"
    elif git show-ref --verify --quiet refs/heads/master; then
        BRANCH="master"
    else
        BRANCH="main"
        git branch -M main
    fi

    git push -u origin $BRANCH

    if [ $? -eq 0 ]; then
        print_success "Code pushed to GitHub successfully!"
    else
        print_error "Failed to push to GitHub!"
        exit 1
    fi
}

# Show deployment information
show_deployment_info() {
    echo ""
    print_success "🎉 Deployment completed successfully!"
    echo ""

    # Extract GitHub username and repo name
    if [[ $REPO_URL =~ github\.com[/:]([^/]+)/([^/]+)\.git ]]; then
        USERNAME="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
    elif [[ $REPO_URL =~ github\.com[/:]([^/]+)/([^/]+) ]]; then
        USERNAME="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
    fi

    PAGES_URL="https://${USERNAME}.github.io/${REPO_NAME}/"

    echo -e "${PURPLE}${HEART} Your romantic invitation will be available at:${NC}"
    echo -e "${CYAN}$PAGES_URL${NC}"
    echo ""
    echo -e "${YELLOW}${SPARKLE} Next steps:${NC}"
    echo "1. Wait 2-5 minutes for GitHub Pages to build and deploy"
    echo "2. Check GitHub Actions: https://github.com/${USERNAME}/${REPO_NAME}/actions"
    echo "3. Enable GitHub Pages: Settings → Pages → Source: GitHub Actions"
    echo "4. Share your romantic link with your love! ${HEART}"
    echo ""
    echo -e "${GREEN}${HEART} May your invitation bring you love and happiness! ${HEART}${NC}"
}

# Main deployment process
main() {
    check_git
    get_repo_url
    get_repo_name
    build_project
    deploy_to_github
    show_deployment_info
}

# Show help
show_help() {
    echo -e "${CYAN}Valentine's Day Concert Invitation Deploy Script${NC}"
    echo ""
    echo "Usage: ./deploy.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  deploy    Deploy to GitHub Pages (default)"
    echo "  help      Show this help message"
    echo ""
    echo "This script will:"
    echo "  1. Initialize Git repository if needed"
    echo "  2. Get or set GitHub repository URL"
    echo "  3. Build the project for production"
    echo "  4. Commit and push changes to GitHub"
    echo "  5. Provide deployment information"
    echo ""
}

# Handle command line arguments
case "${1:-deploy}" in
    "deploy")
        main
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
