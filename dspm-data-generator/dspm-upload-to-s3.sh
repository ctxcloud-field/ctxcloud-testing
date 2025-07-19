#!/usr/bin/env bash

# dspm-upload-to-s3.sh - Upload DSPM data files to S3 and optionally make public

set -euo pipefail

function usage() {
  echo "Usage: $0 [--bucket <bucket-name>] [--dir <directory>] [--public]"
  echo ""
  echo "Options:"
  echo "  --bucket    Name of the S3 bucket to upload to"
  echo "  --dir       Directory of files to upload (default: ./dspm_test_data)"
  echo "  --public    Make uploaded files public"
  exit 1
}

# Defaults
BUCKET_NAME=""
UPLOAD_DIR="./dspm_test_data"
MAKE_PUBLIC=false

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --bucket)
      BUCKET_NAME="$2"
      shift 2
      ;;
    --dir)
      UPLOAD_DIR="$2"
      shift 2
      ;;
    --public)
      MAKE_PUBLIC=true
      shift
      ;;
    *)
      usage
      ;;
  esac
done

# Validate bucket name
if [[ -z "$BUCKET_NAME" ]]; then
  read -rp "Enter S3 bucket name: " BUCKET_NAME
fi

# Ensure AWS CLI is installed
if ! command -v aws &>/dev/null; then
  echo "❌ AWS CLI not found. Please install it to continue."
  exit 1
fi

# Make sure the directory exists
if [[ ! -d "$UPLOAD_DIR" ]]; then
  echo "❌ Directory '$UPLOAD_DIR' not found."
  exit 1
fi

# Create the bucket if it doesn't exist
if ! aws s3 ls "s3://$BUCKET_NAME" &>/dev/null; then
  echo "ℹ️  Bucket does not exist. Creating '$BUCKET_NAME'..."
  aws s3 mb "s3://$BUCKET_NAME"
fi

# Upload files with timestamped prefix
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
for file in "$UPLOAD_DIR"/*; do
  base_file=$(basename "$file")
  s3_path="s3://$BUCKET_NAME/dspm/$TIMESTAMP/$base_file"
  echo "⬆️  Uploading $base_file to $s3_path"
  aws s3 cp "$file" "$s3_path"

  if $MAKE_PUBLIC; then
    echo "🌍 Making $s3_path public"
    aws s3api put-object-acl --bucket "$BUCKET_NAME" --key "dspm/$TIMESTAMP/$base_file" --acl public-read
    echo "🔗 Public URL: https://$BUCKET_NAME.s3.amazonaws.com/dspm/$TIMESTAMP/$base_file"
  fi
done

echo "✅ Upload complete."
