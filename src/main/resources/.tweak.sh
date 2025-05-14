
#######################################
# Clean up the Linux system based on OS
# - Keeps function name 'cleanup' for compatibility
#######################################
cleanup() {
    info "🧹 Starting system cleanup for $OS..."

    case "$OS" in
        ubuntu|debian|raspbian|wsl)
            cleanup_debian_based
            ;;
        manjaro|arch)
            cleanup_arch_based
            ;;
        *)
            error "Unsupported OS: $OS. Skipping cleanup."
            return 1
            ;;
    esac

    info "✅ System cleanup completed for $OS."
}

##########################################
# Clean up the thumbnails from the cache
# - Keeps function name 'cleanupThumbnails'
##########################################
cleanupThumbnails() {
    local cache_path="$HOME/.cache/thumbnails"
    if [[ -d "$cache_path" ]]; then
        info "🗑️ Cleaning thumbnail cache in $cache_path..."
        rm -rf "${cache_path:?}/"*
    else
        warning "Thumbnail cache directory not found: $cache_path"
    fi
}

#######################################
# Internal: Debian-based cleanup
#######################################
cleanup_debian_based() {
    info "[Debian/Ubuntu] Running apt cleanup..."
    sudo apt-get autoclean -y
    sudo apt-get clean
    sudo apt-get autoremove -y
    sudo apt --fix-broken install -y
    sudo apt-get update -y
    sudo apt-get upgrade -y
}

#######################################
# Internal: Arch-based cleanup
#######################################
cleanup_arch_based() {
    info "[Manjaro/Arch] Running pacman/pamac cleanup..."
    pamac clean --build-files --no-confirm || true
    sudo pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null || info "No orphaned packages to remove"
    sudo pacman -Syu --noconfirm
}