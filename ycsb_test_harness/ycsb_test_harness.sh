#!/bin/bash

# Commands used if, then, echo, exit, mkdir

echo "Starting YCSB Test Harness ..."
if [ "$1" == "" ]; then
    echo "Error incorrect input: Please provide a test identifier ..."
    exit
fi

echo "Setting environment variables ..."
TEST_DATE=`date +%d%m%y`
YELLOW="\033[0;33m"
NOCOLOUR="\033[0m"
HOME_NEW=/home/hduser
YCSB_HOME=$HOME_NEW/ycsb-0.11.0
OUTPUT_DIR="$YCSB_HOME/output/$1"

echo "Creating YCSB output directory for workload output at" $OUTPUT_DIR
mkdir -p "$OUTPUT_DIR"

function clean_database {

    if [ "$db" == "mysql" ]; then
        mysql --user="root" --password="password" < ./clear_scripts/user_table_clear.sql  2> /dev/null
    fi
    # NOTE: The 'cassandra2-cql' client has been deprecated. It has been renamed to simply 'cassandra-cql'
    if [ "$db" == "cassandra-cql" ]; then
        $HOME_NEW/cassandra/bin/cqlsh -f ./clear_scripts/user_table_clear.cql
    fi
    if [ "$db" == "mongodb" ]; then
        mongo < ./clear_scripts/user_table_clear.js
    fi
    if [ "$db" == "hbase10" ]; then
        ./clear_scripts/user_table_clear.hbase
    fi
}


function run_workload {

    echo -n -e "${YELLOW}"

    if [ "$db" == "mysql" ]; then
        db='jdbc'
        $YCSB_HOME/bin/ycsb $phaseType $db -P $YCSB_HOME/jdbc-binding/conf/db.properties -P $YCSB_HOME/workloads/$wl -p recordcount=$oc -p operationcount=$oc | tee $OUTPUT_DIR/${db}_${wl}_${oc}_${phaseType}_${TEST_DATE}.txt
        db='mysql'
    fi
    # NOTE: The 'cassandra2-cql' client has been deprecated. It has been renamed to simply 'cassandra-cql'
    if [ "$db" == "cassandra-cql" ]; then
        echo -e "\t\t\t cassandra-cql"
        $YCSB_HOME/bin/ycsb $phaseType $db -P $YCSB_HOME/workloads/$wl -p hosts=localhost -p recordcount=$oc -p operationcount=$oc | tee $OUTPUT_DIR/${db}_${wl}_${oc}_${phaseType}_${TEST_DATE}.txt
    fi
    if [ "$db" == "mongodb" ]; then
        echo -e "\t\t\t mongodb"
        $YCSB_HOME/bin/ycsb $phaseType $db -s -P $YCSB_HOME/workloads/$wl -p recordcount=$oc -p operationcount=$oc | tee $OUTPUT_DIR/${db}_${wl}_${oc}_${phaseType}_${TEST_DATE}.txt
    fi
    if [ "$db" == "hbase10" ]; then
        echo -e "\t\t\t hbase10"
        $YCSB_HOME/bin/ycsb $phaseType $db -P $YCSB_HOME/workloads/$wl -p table=usertable -p columnfamily=family -p recordcount=$oc -p operationcount=$oc | tee $OUTPUT_DIR/${db}_${wl}_${oc}_${phaseType}_${TEST_DATE}.txt
    fi

    echo -n -e "${NOCOLOUR}"
}


echo "Running Workloads ..."
for db in `cat test_config/test_dbs.txt`
do
    ./configure_database_for_ycsb.sh "$db"
    echo -e "DATABASE: $db"

    for wl in `cat test_config/workloads.txt`
    do
        echo -e "\tRUNNING: $wl"
        for oc in `cat test_config/op_counts.txt`

        do
            echo -e "\t\t OPCOUNT: $oc"
            echo -e "\t\t\t  Running clear scripts ..."
            clean_database

            for phaseType in load run
            do
                echo -e "\t\t\t  Running $phaseType phase ..."
                run_workload
            done
        done
        echo -e "\tFINISHED: $wl"
    done
    echo -e "FINISHED: $db"
done
echo "Finished YCSB Test Harness ..."
