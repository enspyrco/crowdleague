# taken from https://github.com/actions/virtual-environments/issues/560#issuecomment-602543882 
VERSION="1.14"
mkdir Iconv
cd Iconv
wget "https://github.com/linux-test-project/lcov/releases/download/v1.14/lcov-$VERSION.tar.gz"
tar -xzf "lcov-$VERSION.tar.gz"
cd "lcov-$VERSION"
sudo make install