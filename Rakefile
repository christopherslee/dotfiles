# copied and inspired from the following:
# https://github.com/ryanb/dotfiles
# https://github.com/hpoydar/dotfiles

require 'rake'
require 'erb'

namespace :install do
  desc "install dot files into home directory"
  task :all => [:oh_my_zsh, :homebrew, :janus, :configure_vim, :fonts] do
  end

  desc "configure janus"
  task :configure_janus do
    install_dotfiles("vimrc.after")
    if File.exist?(File.join(ENV['HOME'], '.gvimrc.after'))
      msg "backing up old .gvimrc.after to .gvimrc.after.old"
      sh "mv ~/.gvimrc.after ~/.gvimrc.after.old"
    end
    sh "ln -s ~/.vimrc.after ~/.gvimrc.after"
    unless File.exist?(File.join(ENV['HOME'], '.janus', 'StripWhiteSpaces'))
      sh "git clone https://github.com/gagoar/StripWhiteSpaces.git ~/.janus/StripWhiteSpaces"
    end
    unless File.exist?(File.join(ENV['HOME'], '.janus', 'tabular'))
      sh "git clone https://github.com/godlygeek/tabular.git ~/.janus/tabular"
    end
    unless File.exist?(File.join(ENV['HOME'], '.janus', 'vim-powerline'))
      sh "git clone https://github.com/Lokaltog/vim-powerline ~/.janus/vim-powerline"
    end
    unless File.exists?(File.join(ENV['HOME'], '.janus', 'vim-colors-solarized'))
      sh "git clone https://github.com/altercation/vim-colors-solarized ~/.janus/vim-colors-solarized"
    end
    # install run in terminal scripts
    sh "ln -s ~/dotfiles/janus/run_in_terminal ~/.janus/run_in_terminal"
    sh "ln -s ~/dotfiles/janus/tools ~/.janus/tools"
  end

  desc "install fonts"
  task :fonts do
    msg "Installing fonts. You'll have to install them into Font Book still."
    sh "cp fonts/*.otf ~/Library/Fonts/."
  end

  desc "install homebrew"
  task :homebrew do
    if not File.exists? "/usr/local/bin/brew"
      msg "Installing homebrew"
      sh "ruby <(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
    end

    msg "Update homebrew and formulae"
    sh "brew update"

    %w(ack git ctags fasd macvim zsh-completions).each do |pkg|
      msg "Installing #{pkg}"
      begin
        sh "brew install #{pkg}"
      rescue => e
        msg "Looks like #{pkg} is already installed"
      end
    end
  end

  desc "install janus"
  task :janus do
    install_prompt("janus", File.join(ENV['HOME'], ".janus")) do
      system %Q{curl -Lo- https://bit.ly/janus-bootstrap | bash}
    end
  end

  desc "miscellaneous dotfile installation"
  task :misc do
    %w(gemrc irbrc gitconfig.erb).each do |f|
      msg "Installing #{f}"
      install_dotfiles(f)
    end
  end

  desc "install oh-my-zsh"
  task :oh_my_zsh do
    install_prompt("oh-my-zsh", File.join(ENV['HOME'], ".oh-my-zsh")) do
      system %Q{curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh}
    end
    #install_dotfiles("oh-my-zsh")
  end

  desc "install pow"
  task :pow do
    install_prompt("pow", File.join(ENV['HOME'], ".pow")) do
      system %Q{curl get.pow.cx | sh}
    end
  end

  desc "install rvm"
  task :rvm do
    install_prompt("rvm", File.join(ENV['HOME'], '.rvm')) do
      system %Q{curl -L https://get.rvm.io | bash -s stable --ruby}
    end
  end
end

def install_prompt(name, filename)
  if File.exist?(filename)
    msg "found #{filename}, skiping installation"
    return
  end

  print "install #{name}? [ynq]"
  case $stdin.gets.chomp
  when 'y'
    msg "installing #{name}"
    yield
  when 'q'
    exit
  else
    msg "skipping #{name} installation"
  end
end

def install_dotfiles(dir_pattern)
  replace_all = false
  Dir[dir_pattern].each do |file|
    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def msg(m)
  puts ""
  puts "+++ #{m}"
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end
