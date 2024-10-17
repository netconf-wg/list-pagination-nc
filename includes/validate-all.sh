#!/bin/bash

run_unix_cmd() {
  # $1 is the line number
  # $2 is the cmd to run
  # $3 is the expected exit code
  output=`$2 2>&1`
  exit_code=$?
  if [[ $exit_code -ne $3 ]]; then
    printf "failed (incorrect exit status code) on line $1.\n"
    printf "  - exit code: $exit_code (expected $3)\n"
    printf "  - command: $2\n"
    if [[ -z $output ]]; then
      printf "  - output: <none>\n\n"
    else
      printf "  - output: <starts on next line>\n$output\n\n"
    fi
    exit 1
  fi
}

DATE=`date +%Y-%m-%d`

# Validation of the "list-pagination" module

printf "Testing ietf-list-pagination-nc.yang (pyang)..."
command="pyang -Werror --ietf --max-line-length=72 ../ietf-list-pagination-nc\@*.yang"
run_unix_cmd $LINENO "$command" 0
command="pyang --canonical ../ietf-list-pagination-nc\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ietf-list-pagination-nc.yang (yanglint)..."
command="yanglint ../ietf-list-pagination-nc\@*.yang"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"


# Validate examples

printf "Testing ex-api-combo-rpc.xml...DISABLED!\n" # FIXME: yanglint can't validate <get> *requests*?!
#command="yanglint -t get ietf-datastores@2018-02-14.yang ../../list-pagination/includes/example-social@$DATE.yang ../../list-pagination/ietf-list-pagination@$DATE.yang ../ietf-list-pagination-nc@$DATE.yang ex-api-combo-rpc.xml"
#run_unix_cmd $LINENO "$command" 0
#printf "okay.\n"

printf "Testing ex-api-combo-rpc-inner-payload.xml..." 
sed -e 's/^}/uses pagination-parameters;}/' ../ietf-list-pagination-nc@$DATE.yang > ietf-list-pagination-nc@$DATE.yang
command="yanglint -t config ../../list-pagination/ietf-list-pagination@$DATE.yang ietf-list-pagination-nc@$DATE.yang ex-api-combo-rpc-inner-payload.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

printf "Testing ex-api-combo-rpc-reply.xml...DISABLED!\n" # FIXME: yanglint can't validate whole <get> response
#command="yanglint -t get ietf-datastores@2018-02-14.yang ../../list-pagination/includes/example-social@$DATE.yang ../../list-pagination/ietf-list-pagination@$DATE.yang ../ietf-list-pagination-nc@$DATE.yang ex-api-combo-rpc-reply.xml"
#run_unix_cmd $LINENO "$command" 0
#printf "okay.\n"

printf "Testing ex-api-combo-rpc-reply-inner-payload.xml..." 
command="yanglint -t get ../../list-pagination/includes/example-social@$DATE.yang ../../list-pagination/ietf-list-pagination@$DATE.yang  ex-api-combo-rpc-reply-inner-payload.xml"
run_unix_cmd $LINENO "$command" 0
printf "okay.\n"

