#!/bin/bash

# description: Starts and stops the Oracle listener and database

# Set ORACLE_HOME to the Oracle Home where the lsnrctl and dbstart
# commands can be found
ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE

# Set ORACLE_OWNER to the user owner of the Oracle XE
ORACLE_OWNER=oracle

case "$1" in
    'start')
        # Start the listener:
        su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/lsnrctl start";

        # Start the databases:
        su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME"
    ;;

    'stop')
        # Stop the listener:
        su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/lsnrctl stop"

        # Stop the databases:
        su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME"
    ;;
esac