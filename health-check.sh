#!/bin/bash

# 🩺 Valentine's Day DKTT Concert Invitation - Health Check Script
# This script helps diagnose deployment and build issues

set -e

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
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
MAGNIFYING_GLASS="🔍"

echo -e "${PURPLE}${HEART}${HEART}${HEART} Valentine's Day Concert Invitation - Health Check ${HEART}${HEART}${HEART}${NC}"
echo -e "${CYAN}Diagnosing your romantic Vue.js application...${NC}"
echo ""

# Function to print colored output
print_step() {
    echo -e "${BLUE}${MAGNIFYING_GLASS} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# Check system requirements
check_system_requirements() {
    print_step "Checking system requirements..."

    # Check Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js: $NODE_VERSION"
    else
        print_error "Node.js is not installed!"
        return 1
    fi

    # Check npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_success "npm: $NPM_VERSION"
    else
        print_error "npm is not installed!"
        return 1
    fi

    # Check Git
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        print_success "Git: $GIT_VERSION"
    else
        print_error "Git is not installed!"
        return 1
    fi

    echo ""
}

# Check project structure
check_project_structure() {
    print_step "Checking project structure..."

    # Required files
    REQUIRED_FILES=(
        "package.json"
        "vite.config.js"
        "index.html"
        "src/main.js"
        "src/App.vue"
    )

    for file in "${REQUIRED_FILES[@]}"; do
        if [ -f "$file" ]; then
            print_success "$file exists"
        else
            print_error "$file is missing!"
        fi
    done

    # Required directories
    REQUIRED_DIRS=(
        "src"
        "public"
        ".github/workflows"
    )

    for dir in "${REQUIRED_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            print_success "$dir/ directory exists"
        else
            print_error "$dir/ directory is missing!"
        fi
    done

    echo ""
}

# Check package.json configuration
check_package_json() {
    print_step "Checking package.json configuration..."

    if [ -f "package.json" ]; then
        # Check if required scripts exist
        if grep -q '"build".*"vite build"' package.json; then
            print_success "Build script is configured correctly"
        else
            print_error "Build script is missing or incorrect!"
        fi

        if grep -q '"dev".*"vite"' package.json; then
            print_success "Dev script is configured correctly"
        else
            print_error "Dev script is missing or incorrect!"
        fi

        # Show current scripts
        print_info "Available scripts:"
        grep -A 10 '"scripts"' package.json | grep -E '"\w+"' || true
    else
        print_error "package.json not found!"
    fi

    echo ""
}

# Check Vite configuration
check_vite_config() {
    print_step "Checking Vite configuration..."

    if [ -f "vite.config.js" ]; then
        print_success "vite.config.js exists"

        # Check base path configuration
        if grep -q 'base.*Valentine-Invitation' vite.config.js; then
            print_success "Base path is configured for Valentine-Invitation"
        else
            print_warning "Base path might not match your repository name"
            print_info "Current base configuration:"
            grep -n "base" vite.config.js || true
        fi
    else
        print_error "vite.config.js not found!"
    fi

    echo ""
}

# Check dependencies
check_dependencies() {
    print_step "Checking dependencies..."

    if [ -f "package.json" ]; then
        # Check if node_modules exists
        if [ -d "node_modules" ]; then
            print_success "node_modules directory exists"
        else
            print_warning "node_modules directory not found"
            print_info "Run 'npm install' to install dependencies"
        fi

        # Check if package-lock.json exists
        if [ -f "package-lock.json" ]; then
            print_success "package-lock.json exists (good for reproducible builds)"
        else
            print_warning "package-lock.json not found"
        fi

        # Show dependency status
        print_info "Dependency status:"
        if [ -d "node_modules" ]; then
            npm list --depth=0 2>/dev/null | head -10 || print_warning "Some dependency issues detected"
        fi
    fi

    echo ""
}

# Test build process
test_build() {
    print_step "Testing build process..."

    if [ -f "package.json" ] && [ -d "node_modules" ]; then
        print_info "Running npm run build..."

        if npm run build; then
            print_success "Build completed successfully!"

            # Check if dist folder was created
            if [ -d "dist" ]; then
                print_success "dist/ directory created"

                # Check if index.html exists in dist
                if [ -f "dist/index.html" ]; then
                    print_success "dist/index.html exists"

                    # Show file sizes
                    print_info "Build output:"
                    ls -lah dist/ 2>/dev/null || true
                else
                    print_error "dist/index.html not found!"
                fi
            else
                print_error "dist/ directory not created!"
            fi
        else
            print_error "Build failed!"
            return 1
        fi
    else
        print_warning "Cannot test build - missing package.json or node_modules"
        print_info "Run 'npm install' first"
    fi

    echo ""
}

# Check GitHub configuration
check_github_config() {
    print_step "Checking GitHub configuration..."

    # Check if .github/workflows/deploy.yml exists
    if [ -f ".github/workflows/deploy.yml" ]; then
        print_success "GitHub Actions workflow file exists"

        # Check workflow configuration
        if grep -q "actions/checkout@v4" .github/workflows/deploy.yml; then
            print_success "Using modern GitHub Actions (checkout@v4)"
        else
            print_warning "Might be using outdated GitHub Actions"
        fi

        if grep -q "actions/setup-node@v4" .github/workflows/deploy.yml; then
            print_success "Using modern Node.js setup (setup-node@v4)"
        else
            print_warning "Might be using outdated Node.js setup"
        fi
    else
        print_error ".github/workflows/deploy.yml not found!"
        print_info "GitHub Actions workflow is required for deployment"
    fi

    # Check Git remote
    if git remote get-url origin >/dev/null 2>&1; then
        REPO_URL=$(git remote get-url origin)
        print_success "Git remote origin: $REPO_URL"

        # Extract repo name
        REPO_NAME=$(basename "$REPO_URL" .git)
        print_info "Repository name: $REPO_NAME"

        # Check if Vite config matches repo name
        if grep -q "$REPO_NAME" vite.config.js; then
            print_success "Vite config base path matches repository name"
        else
            print_warning "Vite config base path might not match repository name"
            print_info "Expected: /$REPO_NAME/"
            print_info "Current:"
            grep -n "base" vite.config.js || true
        fi
    else
        print_error "No Git remote origin configured!"
        print_info "Add your GitHub repository with: git remote add origin <your-repo-url>"
    fi

    echo ""
}

# Show deployment checklist
show_deployment_checklist() {
    print_step "Deployment Checklist:"
    echo ""
    echo -e "${CYAN}Before deploying, make sure:${NC}"
    echo "1. ${CHECK} All files are committed to Git"
    echo "2. ${CHECK} Repository is pushed to GitHub"
    echo "3. ${CHECK} GitHub Pages is enabled in repository settings"
    echo "4. ${CHECK} GitHub Pages source is set to 'GitHub Actions'"
    echo "5. ${CHECK} Base path in vite.config.js matches your repository name"
    echo "6. ${CHECK} Build passes locally (npm run build)"
    echo ""
    echo -e "${YELLOW}Common deployment issues:${NC}"
    echo "• Wrong base path in vite.config.js"
    echo "• GitHub Pages not enabled"
    echo "• Node.js version mismatch"
    echo "• Missing dependencies"
    echo "• Build errors in components"
    echo ""
}

# Main health check
main() {
    local exit_code=0

    check_system_requirements || exit_code=1
    check_project_structure || exit_code=1
    check_package_json || exit_code=1
    check_vite_config || exit_code=1
    check_dependencies || exit_code=1

    # Only run build test if basic checks pass
    if [ $exit_code -eq 0 ]; then
        test_build || exit_code=1
    fi

    check_github_config || exit_code=1
    show_deployment_checklist

    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}${HEART} Health check passed! Your project looks ready for deployment! ${HEART}${NC}"
    else
        echo -e "${RED}${CROSS} Health check found issues. Please fix them before deploying.${NC}"
    fi

    return $exit_code
}

# Show help
show_help() {
    echo -e "${CYAN}Valentine's Day Concert Invitation - Health Check Script${NC}"
    echo ""
    echo "Usage: ./health-check.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  check     Run full health check (default)"
    echo "  build     Test build process only"
    echo "  deps      Check dependencies only"
    echo "  help      Show this help message"
    echo ""
}

# Handle command line arguments
case "${1:-check}" in
    "check")
        main
        ;;
    "build")
        test_build
        ;;
    "deps")
        check_dependencies
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
