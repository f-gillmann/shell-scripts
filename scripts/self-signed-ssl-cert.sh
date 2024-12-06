#!/bin/bash
# check if the required arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: generate-ssl-cert <number_of_days> <domain> [output_dir]"
  echo "Example: generate-ssl-cert 1825 '*.home.local' ./directory"
  exit 1
fi

# set the output directory
if [ -z "$3" ]; then
  output_dir="."
else
  output_dir="$3"
fi

# extract the domain name without the wildcard (if present)
domain_name=$(echo "$2" | sed 's/^\*\.//')

# generate the certificate with the specified parameters
openssl req -x509 -nodes -days "$1" -newkey rsa:2048 \
  -keyout "$output_dir/$domain_name.key" \
  -out "$output_dir/$domain_name.crt" \
  -subj "/CN=$2" \
  -addext "subjectAltName=DNS:$2"

echo "Certificate generated successfully in $output_dir!"
