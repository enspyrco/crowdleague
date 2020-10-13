VERSION="1.14"
mkdir Iconv
cd Iconv
wget "https://github.com/linux-test-project/lcov/releases/download/v1.14/lcov-$VERSION.tar.gz"
tar -xzf "lcov-$VERSION.tar.gz"
cd "lcov-$VERSION"
sudo make install