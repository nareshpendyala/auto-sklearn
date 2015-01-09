# First, create a temporary directory for zipping files
rm .zip -rf
rm build -rf
rm submission.zip
mkdir .zip
mkdir build

# Build an installable for the submission project
python setup.py sdist
pip install dist/AutoML2015-0.1dev.tar.gz -t .zip -t .zip -b build --no-deps

# Add dependencies
pip install git+https://github.com/mfeurer/HPOlibConfigSpace#egg=HPOlibConfigSpace0.1dev -t .zip/AutoML2015/lib/ -b build --no-deps
pip install git+https://bitbucket.org/mfeurer/autosklearn#egg=AutoSklearn -t .zip/AutoML2015/lib/ -b build --no-deps

# Download SMAC
if [ ! -e smac-v2.08.00-master-731.tar.gz ]
then
    wget http://www.cs.ubc.ca/labs/beta/Projects/SMAC/smac-v2.08.00-master-731.tar.gz
fi
tar -xf smac-v2.08.00-master-731.tar.gz
mv smac-v2.08.00-master-731 .zip/AutoML2015/lib/

# Get CMA
wget https://www.lri.fr/~hansen/cma.py
mv cma.py .zip/AutoML2015/lib/

# Copy Java
cp jre1.8.0_25 .zip/AutoML2015/lib/ -r

# Copy lockfile
wget https://pypi.python.org/packages/source/l/lockfile/lockfile-0.10.2.tar.gz#md5=1aa6175a6d57f082cd12e7ac6102ab15
tar -xf lockfile-0.10.2.tar.gz
mv lockfile-0.10.2/lockfile .zip/AutoML2015/lib/
rm lockfile-0.10.2.tar.gz

# Download runsolver, compile and mv it
wget http://www.cril.univ-artois.fr/~roussel/runsolver/runsolver-3.3.4.tar.bz2
tar -xf runsolver-3.3.4.tar.bz2
cd runsolver/src
make
cd ../../
cp runsolver/src/runsolver .zip/AutoML2015/lib/
rm runsolver -r
rm runsolver-3.3.4.tar.bz2

# Clean up the submission directory
find -name "*.egg-info" -exec rm -rf {} \;
find .zip -name "*.pyc" -exec rm -rf {} \;
find .zip -name "*~" -exec rm -rf {} \;

# Zip it
rm submission.zip
cd .zip/AutoML2015
zip -r ../../submission.zip *
cd ../..