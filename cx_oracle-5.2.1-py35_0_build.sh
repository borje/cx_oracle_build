# Build Python 3.5 conda package for cx_oracle 5.2.1 on Linux
# Currently(2016-07-09) only cx_oracle-5.1.2-py27 is avalible in the conda repository.
#
# Based on http://conda.pydata.org/docs/build_tutorials/pkgs.html
#
# Build environment: Ubuntu 16.04 with Anaconda3-4.1.1-Linux-x86_64 installed in $HOME/anaconda3
#
# Download from http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
#  - instantclient-basic-linux.x64-12.1.0.2.0.zip
#  - instantclient-sdk-linux.x64-12.1.0.2.0.zip

#sudo apt-get -y update
#sudo apt-get -y install python3-dev build-essential libaio1 unzip

set -e
conda upgrade conda-build

rm -rf /tmp/cx_oracle_build
mkdir -p /tmp/cx_oracle_build

cp $HOME/Downloads/backup/instant* $HOME/Downloads/
unzip $HOME/Downloads/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /tmp/cx_oracle_build
unzip $HOME/Downloads/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /tmp/cx_oracle_build

ln -s /tmp/cx_oracle_build/instantclient_12_1/libclntsh.so.12.1 /tmp/cx_oracle_build/instantclient_12_1/libclntsh.so

export ORACLE_HOME=/tmp/cx_oracle_build/instantclient_12_1
export LD_LIBRARY_PATH=/tmp/cx_oracle_build/instantclient_12_1

cd /tmp/cx_oracle_build

conda skeleton pypi cx_oracle --version 5.2.1

echo "build:
  script_env:
   - ORACLE_HOME
   - LD_LIBRARY_PATH" | tee -a /tmp/cx_oracle_build/cx_oracle/meta.yaml

#cat /tmp/cx_oracle_build/cx_Oracle/meta.yaml

conda build cx_oracle

ls -lh $HOME/anaconda3/conda-bld/linux-64/cx_oracle-5.2.1-py35_0.tar.bz2

conda install --use-local --yes cx_oracle
conda list oracle

# Clean up
rm $HOME/Downloads/instantclient-*.zip
rm -rf /tmp/cx_oracle_build
conda clean --all --yes

python -c "import cx_Oracle; print(cx_Oracle.__version__)"
