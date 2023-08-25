#! /usr/bin/env zsh
sudo ls  # just to make sure the sudo is activated
cd $HOME

echo "Do you wish to install this xcode-select?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) xcode-select --install; break;;
        No ) break;;
    esac
done

echo "Creating (if needed) necessary files .exports, .aliases, .zprofile"
cd $HOME
touch .exports
touch .aliases
touch .zprofile
echo "Done."

echo "Do you wish to install oh-my-zsh?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) /bin/bash -c "$(curl -fsS: https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; break;;
        No ) break;;
    esac
done

echo 'source $HOME/.exports' >> .zshrc
echo 'source $HOME/.aliases' >> .zshrc

echo "Installing HomeBrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Getting wget"
brew install wget

echo "Symlinking python3 to python"
sudo ln -s /Library/Developer/CommandLineTools/usr/bin/python3 /Library/Developer/CommandLineTools/usr/bin/python
sudo ln -sf /usr/bin/python3 /usr/local/bin/python

sudo ln -s /Library/Developer/CommandLineTools/usr/bin/pip3 /Library/Developer/CommandLineTools/usr/bin/pip
sudo ln -sf /usr/bin/pip3 /usr/local/bin/pip
echo "Done: Symlinking python3 to python"


echo "Do you wish to install nvm?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh)"; break;;
        No ) break;;
    esac
done


echo "Now starting to set the tensorflow for M1/M2 setup"
curl -fsSL https://github.com/conda-forge/miniforge/releases/download/4.13.0-1/Miniforge3-MacOSX-arm64.sh > Miniforge3-MacOSX-arm64.sh
chmod +x Miniforge3-MacOSX-arm64.sh
./Miniforge3-MacOSX-arm64.sh
source ~/.zshrc

echo "Miniconda installation is complete"

echo "Do you wish to *turn off* startup conda *auto* activation?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) conda config --set auto_activate_base false; break;;
        No ) break;;
    esac
done

echo "Installing apple dependencies"
conda activate
conda install -c apple tensorflow-deps
pip install tensorflow-macos==2.9.2
pip install tensorflow-metal==0.5.0
brew install libjpeg
brew install ffmpeg
echo done

echo "Getting Protobuf"
cd $HOME
mkdir protobuf
cd protobuf
wget https://github.com/protocolbuffers/protobuf/releases/download/v22.0-rc3/protoc-22.0-rc-3-osx-aarch_64.zip
unzip ./protoc-22.0-rc-3-osx-aarch_64.zip
cd $HOME

echo 'export PATH="$HOME/protobuf/bin:$PATH"' >> $HOME/.exports
echo 'export CFLAGS="$CFLAGS -I$HOME/protobuf/include"' >> $HOME/.zshrc
echo 'export CPPFLAGS="$CPPFLAGS -I$HOME/protobuf/include"' >> $HOME/.zshrc

echo "Installing base necessary packages"
conda install cached-property
conda install six
conda install -c conda-forge -y absl-py
conda install -c conda-forge -y astunparse
conda install -c conda-forge -y gast
conda install -c conda-forge -y opt_einsum
conda install -c conda-forge -y termcolor
conda install -c conda-forge -y typing_extensions
conda install -c conda-forge -y wheel
conda install -c conda-forge -y typeguard
pip install wrapt==1.14.1
pip install flatbuffers==1.12
pip install tensorflow_estimator==2.9.0
pip install google_pasta==0.2.0
pip install protobuf==3.19.4
pip install tensorboard==2.9.1
pip install numpy==1.24.1
pip install pandas==1.4.3
pip install keras_preprocessing==1.1.2
conda install -c conda-forge scikit-learn
conda install -y matplotlib jupyterlab
conda install -y tornado==6.1
conda install -y jupyter-client==7.3.2
echo "Done"

echo "Installing tensorflow addons and tensorflow text"
mkdir -p $HOME/tensorflow_addons/
cd $HOME/tensorflow_addons/
wget https://github.com/sun1638650145/Libraries-and-Extensions-for-TensorFlow-for-Apple-Silicon/releases/download/v2.9/tensorflow_addons-0.17.1-cp39-cp39-macosx_11_0_arm64.whl
wget https://github.com/sun1638650145/Libraries-and-Extensions-for-TensorFlow-for-Apple-Silicon/releases/download/v2.9/tensorflow_text-2.9.0-cp39-cp39-macosx_11_0_arm64.whl
cd $HOME/tensorflow_addons/
pip install tensorflow_addons-0.17.1-cp39-cp39-macosx_11_0_arm64.whl
pip install tensorflow_text-2.9.0-cp39-cp39-macosx_11_0_arm64.whl
echo "Done"

echo "Installing tensorflow-io"
cd $HOME
git clone https://github.com/tensorflow/io.git
cd io
git checkout tags/v0.26.0 -b v0_26_0
python setup.py -q bdist_wheel
cd dist
pip install --no-deps tensorflow_io-0.26.0-cp39-cp39-macosx_11_0_arm64.whl
cd $HOME
echo "Done"

echo "Installing additional base pip packages"
pip install tf_slim==1.1.0
pip install seaborn==0.11.2
pip install statsmodels==0.13.2
pip install surprise==0.1
pip install opencv-python==4.6.0.66
pip install segmentation-models==1.0.1
pip install gensim==4.2.0

echo "Installing optional packages"

install_rl() {
    echo "Installing Rl related packages"
    pip install gym==0.21.0
    pip install gym-notices==0.0.8
    pip install pybullet==3.2.5
    pip install pygame==2.1.2
    pip install pyglet==1.5.27
    pip install stable-baselines3==1.7.0
    pip install keras-rl==0.4.2
}

install_ka() {
    echo "installing keras applications"
    pip install Keras-Applications==1.0.8
}

install_nltk() {
    echo "Installing nltk"
    pip install nltk==3.7
}

install_ml_extras() {
    echo "Instaling ml Extras"
    echo "1. Levenshtein Test pack "
    pip install python-Levenshtein==0.12.2
    echo "2. wordcloud utils"
    pip install wordcloud==1.8.2.2
    echo "3. xg boost"
    pip install xgboost==1.6.2
    echo "4. yellowbrick"
    pip install yellowbrick==1.5
}

install_pyspark() {
    echo "Installing pyspark"
    pip install pyspark==3.3.1
}

# RL
echo "Do you wish to install rl related packages?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_rl; break;;
        No ) break;;
    esac
done

# Keras pretrained model
echo "Do you wish to install keras applications?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_ka; break;;
        No ) break;;
    esac
done

# nltk
echo "Do you wish to install nltk package?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_nltk; break;;
        No ) break;;
    esac
done

# ml extra
echo "Do you wish to install ml extra package?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_ml_extras; break;;
        No ) break;;
    esac
done

# pyspark
echo "Do you wish to install pyspark?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) install_pyspark; break;;
        No ) break;;
    esac
done


echo "All the best; Enjoy the setup now"
