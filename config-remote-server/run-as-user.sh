#/bin/bash

mirror=$1

cd

# place .ssh
mkdir -p .ssh
cat /tmp/*.pub >> .ssh/authorized_keys

# install oh-my-zsh
sh -c "$(wget -O- https://install.ohmyz.sh/ | grep -v 'exec zsh -l')"
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# configure .zshrc
# sed -i '/^ZSH_THEME=/s/.*/ZSH_THEME=powerlevel10k\/powerlevel10k/' .zshrc
sed -i 's/^\(ZSH_THEME=\).*/\1powerlevel10k\/powerlevel10k/g' .zshrc
cat >> .zshrc << END
export PATH="$HOME/".local/bin:'$PATH'
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
export EDITOR='hx'
bindkey -v
END

# configure helix
mkdir -p .config/helix
cat > .config/helix/config.toml << END
theme = "catppuccin_mocha"

[editor]
true-color = true
END

cat > .config/helix/language.toml << END
[[language]]
name = "python"
auto-format = true
END

# pip configuration
if [ -n $mirror ]; then
  python3 -m pip install -i https://mirror.nju.edu.cn/pypi/web/simple --upgrade pip
  pip config set global.index-url https://mirror.nju.edu.cn/pypi/web/simple
else
  python -m pip install --upgrade pip
fi

# pip package installation
pip install poetry
