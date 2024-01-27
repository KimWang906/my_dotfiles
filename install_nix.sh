#!/bin/bash
KERNEL_VERSION=$(uname -r)
IS_SYSTEMD=""
if [[ -f /etc/wsl.conf ]]; then
 IS_SYSTEMD=$(cat /etc/wsl.conf)
fi

if ! command -v nix &>/dev/null; then
 if [[ $KERNEL_VERSION == *"microsoft"* ]]; then
 echo "Detected WSL"
 echo "Installing nix.."
 if [[ $IS_SYSTEMD == *"systemd=true"* ]]
 then
   echo "SYSTEMD IS ON"
   sh <(curl -L https://nixos.org/nix/install) --daemon
 else
   echo "SYSTEMD IS OFF"
   sh <(curl -L https://nixos.org/nix/install) --no-daemon
 fi
 elif [[ $KERNEL_VERSION == *"Apple"* ]]; then
 echo "Detected Mac"
 echo "Installing nix.."
 sh <(curl -L https://nixos.org/nix/install) --daemon
 elif [[ $KERNEL_VERSION == *"Linux"* ]]; then
 echo "Detected Linux"
 echo "Installing nix.."
 sh <(curl -L https://nixos.org/nix/install) --daemon
 fi
fi

bash | nix-env -iA nixpkgs.direnv

case "$SHELL" in
 */bash)
    echo "eval \"\$(direnv hook bash)\"" >> ~/.bashrc
    source ~/.bashrc
    ;;
 */zsh)
    echo "eval \"\$(direnv hook zsh)\"" >> ~/.zshrc
    source ~/.zshrc
    ;;
 */fish)
    echo "direnv hook fish | source" >> ~/.config/fish/config.fish
    ;;
 *)
    echo "Unknown shell."
    ;;
esac

