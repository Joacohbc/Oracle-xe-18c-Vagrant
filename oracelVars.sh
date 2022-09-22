#!/bin/bash

# Add to /etc/profile.d/oracleVars.sh
echo ">> VARIABLES SETTED <<"
export ORACLE_SID=XE
export ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE
export PATH=$PATH:$ORACLE_HOME/bin