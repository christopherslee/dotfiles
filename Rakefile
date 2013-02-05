# copied and inspired from the following:
# https://github.com/ryanb/dotfiles
# https://github.com/hpoydar/dotfiles

require 'rake'
require 'erb'

namespace :install do
  desc "everything"
  task :all => [:oh_my_zsh, :homebrew, :janus, :configure_vim, :configure_git, :link_scripts, :fonts, :misc_dotfile] do
  end

  desc "configure git"
  task :configure_git do
    install_dotfiles("gitconfig.erb")
    install_dotfiles("githelpers")
  end

  desc "configure janus"
  task :configure_janus do
    install_dotfiles("vimrc.after")
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
    unless File.exists?(File.join(ENV['HOME'], '.janus', 'run_in_terminal'))
      sh "ln -s ~/dotfiles/janus/run_in_terminal ~/.janus/run_in_terminal"
    end
    unless File.exists?(File.join(ENV['HOME'], '.janus', 'tools'))
      sh "ln -s ~/dotfiles/janus/tools ~/.janus/tools"
    end
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

  desc "link files in scripts to /usr/local/bin"
  task :link_scripts do
    Dir["scripts/**"].each do |file|
      filename = file.split("/").last
      if File.exist?("/usr/local/bin/#{filename}")
         msg "/usr/local/bin/#{filename} already exists, skipping."
       else
        system %Q{ln -s "$PWD/scripts/#{filename}" "/usr/local/bin/#{filename}"}
        msg "Installed scripts/#{filename} as /usr/local/bin/#{filename}"
      end
    end
  end

  desc "miscellaneous dotfile installation"
  task :misc_dotfile do
    %w(gemrc irbrc).each do |f|
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
        replace_dotfile(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_dotfile(file)
        when 'y'
          replace_dotfile(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_dotfile(file)
    end
  end
end

# link the source file to a target dotfile in the user's home directory as a dotfile
# if the source file is an erb file, render the erb file before writing (no sym link)
def link_dotfile(file)
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

def replace_dotfile(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_dotfile(file)
end
