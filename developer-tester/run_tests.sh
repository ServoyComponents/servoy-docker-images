#!/bin/bash

test_result_dir="/tmp/test_results"
test_exports_dir="/tmp/test_exports"
output_dir="/usr/home/servoy"
workspace="/servoy_code"
properties_file="/usr/home/servoy/application_server/servoy.properties"

# ####################################################################################################
# Locate our supporting JARs and executables
# ####################################################################################################

# Can't use find_developer_plugin here since we're looking for a folder.
java_path=$(ls /usr/home/servoy/developer/plugins/ | grep "com.servoy.eclipse.jre.linux.")
if [[ -z "${java_path}" ]]; then
    # Use the system Java (JAVA_HOME is already set)
    java_path="java"
else
    export JAVA_HOME="/usr/home/servoy/developer/plugins/${java_path}/jre"
    java_path="/usr/home/servoy/developer/plugins/${java_path}/jre/bin/java"
fi

junit_path=$(ls /usr/home/servoy/developer/plugins/ | grep -E "org.junit_.*.jar$")
if [[ -z "${junit_path}" ]]; then
    junit_path=$(ls /usr/home/servoy/developer/plugins/ | grep -E "org.junit_4.*")
    if [[ -z "${junit_path}" ]]; then
        echo "Could not find JUnit path."
        exit 1
    else
        junit_path="/usr/home/servoy/developer/plugins/${junit_path}/junit.jar"
        if [[ -f "${junit_path} " ]]; then
            echo "Could not find JUnit path."
            exit 1
        fi
    fi
fi
junit_path="/usr/home/servoy/developer/plugins/${junit_path}"

# ####################################################################################################
# Run the tests
# ####################################################################################################
if [[ ! -d ${test_result_dir} ]]; then
    mkdir $test_result_dir
fi
if [[ ! -d ${test_exports_dir} ]]; then
    mkdir $test_exports_dir
fi

# Run our unit tests
ant \
  -lib "${junit_path}" \
  -Dservoy.test.target-exports="${test_result_dir}" \
  -Dservoy.test.property.file="${properties_file}" \
  -Dservoy.developer.dir="/usr/home/servoy/developer/" \
  -Dservoy.app_server.dir="/usr/home/servoy/application_server/" \
  -Djunit.result.dir="${test_result_dir}" \
  -Dsmart.test.exports.dir="${test_exports_dir}" \
  -DWORKSPACE="/servoy_code" \
  -Djava.awt.headless=true \
  "$@" \
  -f /usr/home/servoy/application_server/jenkins_build.xml \
  main_smart
