#!/bin/bash

export ORACLE_HOME=oracle_client_12_1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/oracle_client_12_1

#./test.py
python -c "import cx_Oracle; print(cx_Oracle.__version__)"
echo ":)"

