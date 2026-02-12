#!/usr/bin/env bash

set -e
operating_system=$1
namespace="local"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
if [ ! -f "typst.toml" ]; then
    echo "Error: typst.toml not found"
    exit 1
fi

package_name=$(grep '^name = ' typst.toml | sed 's/name = "\(.*\)"/\1/')
version=$(grep '^version = ' typst.toml | sed 's/version = "\(.*\)"/\1/')

if [ -z "$package_name" ] || [ -z "$version" ]; then
    echo "Error: Failed to extract package name or version from typst.toml"
    exit 1
fi

echo "Package name: $package_name"
echo "Version: $version"

if [ "$operating_system" == "macos" ]; then
    data_dir="$HOME/Library/Application Support"
elif [ "$operating_system" == "linux" ]; then
    data_dir="$HOME/.local/share"
else
    echo "Error: Unsupported OS"
    exit 1
fi

# Typst looks for @local packages under: {data_dir}/typst/packages/local/
# Set target directory (using namespace)
target_dir="$data_dir/typst/packages/$namespace/$package_name/$version"

echo "Install directory: $target_dir"

# Remove existing installation if present
if [ -e "$target_dir" ]; then
    echo "Removing existing installation: $target_dir"
    rm -rf "$target_dir"
fi

# Create parent directory
mkdir -p "$(dirname "$target_dir")"

if [ $? -ne 0 ]; then
    echo "Error: Failed to create parent directory"
    exit 1
fi

# Create symbolic link
echo "Creating symbolic link..."
ln -sf "$PROJECT_ROOT" "$target_dir"

echo ""
echo "✓ Symbolic link created successfully!"
echo ""
echo "Source: $PROJECT_ROOT"
echo "Linked to: $target_dir"
echo ""
echo "You can now import this package in your Typst documents:"
echo "  #import \"@$namespace/$package_name:$version\": *"
echo ""
echo "Note: Since this is a symbolic link, any changes to source files will take effect immediately."
