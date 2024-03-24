#!/bin/bash

#  Version.sh
#  This script is designed to increment the build number consistently.
#  MdEditor
#
#  Created by Aksilont on 12.03.2024.
#  Copyright © 2024 EncodedTeam. All rights reserved.

# Navigating to the directory inside the source root.
cd "$SRCROOT/$PRODUCT_NAME/Environments"

# Get the current date in the format "YY.MM.DD.".
current_date=$(date "+%y.%m.%d.")

# Parse the 'Config.xcconfig' file to retrieve the previous build number.
# The 'awk' command is used to find the line containing "BUILD_NUMBER" using regex
# and the 'tr' command is used to remove any spaces.
previous_build_number=$(awk -F "=" '/BUILD_NUMBER/ {print $2}' Config.xcconfig | tr -d ' ')

# Extract the date part and the counter part from the previous build number.
previous_date="${previous_build_number:0:9}"
counter="${previous_build_number:9}"

# If the current date matches the date from the previous build number,
# increment the counter. Otherwise, reset the counter to 1.
new_counter=1
if [ "$current_date" = "$previous_date" ]; then
	new_counter=$((counter + 1))
fi

# Combine the current date and the new counter to create the new build number.
new_build_number="${current_date}${new_counter}"

# Use 'sed' command to replace the previous build number with the new build
# number in the 'Config.xcconfig' file.
sed -i -e "/BUILD_NUMBER =/ s/= .*/= $new_build_number/" Config.xcconfig

# Remove the backup file created by 'sed' command.
rm -f Config.xcconfig-e
