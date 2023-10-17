

#!/bin/bash
# Initialize variables to keep track of total size

#!/bin/bash

# Check if PNG or JPG files exist in the current directory
if [[ $(find . -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" \)) ]]; then
    echo "PNG or JPG files found in the current directory"
    # Perform your action here
else
    echo "No PNG or JPG files found in the current directory"
    exit 1
fi

total_size=0

while true; do
  read -p "Enter a keyword (owner, group, or other): " keyword
  case "$keyword" in
    owner|group|other)
      break  # Valid keyword provided, exit the loop
      ;;
    *)
      echo "Invalid keyword. Please enter 'owner', 'group', or 'others'."
      ;;
  esac
done


# Prompt the user to enter another keyword (read, write, or execute) until valid input is provided
while true; do
  read -p "Enter a keyword (read, write, or execute): " permission
  case "$permission" in
    read|write|execute)
      break  # Valid permission keyword provided, exit the loop
      ;;
    *)
      echo "Invalid keyword. Please enter 'read', 'write', or 'execute'."
      ;;
  esac
done


invert_owner_write_permission() {
  local file="$1"
  local owner_write_permissions
  owner_write_permissions=$(stat -c "%A" "$file" | cut -c 2-4)
  if [[ "$owner_write_permissions" == *w* ]]; then
    chmod u-w "$file"  # Remove owner's write permission
  else
    chmod u+w "$file"  # Add owner's write permission
  fi
}

invert_owner_read_permission() {
  local file="$1"
  local owner_read_permissions
  owner_read_permissions=$(stat -c "%A" "$file" | cut -c 2-4)

  if [[ "$owner_read_permissions" == *r* ]]; then
     chmod u-r "$file" # Remove owner;s read permission 
  else
     chmod u+r "$file" # Add owners read permission
  fi

}

invert_owner_execute_permission() {
  local file="$1"
  local owner_execute_permissions
  owner_execute_permissions=$(stat -c "%A" "$file" | cut -c 2-4)

  if [[ "$owner_execute_permissions" == *x* ]]; then
     chmod u-x "$file" # Remove owner;s read permission 
  else
     chmod u+x "$file" # Add owners read permission
  fi

}


#group function start
invert_group_write_permission() {
  local file="$1"
  local group_write_permissions
  group_write_permissions=$(stat -c "%A" "$file" | cut -c 5-7)
  if [[ "$group_write_permissions" == *w* ]]; then
    chmod g-w "$file"  # Remove owner's write permission
  else
    chmod g+w "$file"  # Add owner's write permission
  fi
}

invert_group_read_permission() {

  local file="$1"
  local group_read_permissions
  group_read_permissions=$(stat -c "%A" "$file" | cut -c 5-7)
  if [[ "$group_read_permissions" == *r* ]]; then
    chmod g-r "$file"  # Remove owner's write permission
  else
    chmod g+r "$file"  # Add owner's write permission
  fi
}

invert_group_execute_permission() {
  local file="$1"
  local group_execute_permissions
  group_execute_permissions=$(stat -c "%A" "$file" | cut -c 5-7)
  if [[ "$group_execute_permissions" == *x* ]]; then
    chmod g-x "$file"  # Remove owner's write permission
  else
    chmod g+x "$file"  # Add owner's write permission
  fi
}



invert_other_write_permission() {
  local file="$1"
  local other_write_permissions
  other_write_permissions=$(stat -c "%A" "$file" | cut -c 8-10)
  if [[ "$other_write_permissions" == *w* ]]; then
    chmod o-w "$file"  # Remove other's write permission
  else
    chmod o+w "$file"  # Add other's write permission
  fi
}

invert_other_read_permission() {
  local file="$1"
  local other_read_permissions
  other_read_permissions=$(stat -c "%A" "$file" | cut -c 8-10)

  if [[ "$other_read_permissions" == *r* ]]; then
     chmod o-r "$file" # Remove other;s read permission 
  else
     chmod o+r "$file" # Add others read permission
  fi

}

invert_other_execute_permission() {
  local file="$1"
  local other_execute_permissions
  other_execute_permissions=$(stat -c "%A" "$file" | cut -c 8-10)

  if [[ "$other_execute_permissions" == *x* ]]; then
     chmod o-x "$file" # Remove other;s read permission 
  else
     chmod o+x "$file" # Add others read permission
  fi

}

#group function end

# Iterate through all .png and .jpg files in the current directory
for file in *.png *.jpg; do
  # Check if the file is not a directory (i.e., a regular file)
  if [[ -f "$file" ]]; then
    # Get the file size in bytes
    size=$(stat -c %s "$file")

                if [[ "$keyword" == "owner" && "$permission" == "write" ]]; then
                        invert_owner_write_permission "$file"
                elif [[ "$keyword" == "owner" && "$permission" == "read" ]]; then
                        invert_owner_read_permission "$file"
                elif [[ "$keyword" == "owner" && "$permission" == "execute" ]]; then
                        invert_owner_execute_permission "$file"
                elif [[ "$keyword" == "group" && "$permission" == "write" ]]; then
                       invert_group_write_permission "$file"
                elif [[ "$keyword" == "group" && "$permission" == "read" ]]; then
                       invert_group_read_permission "$file"
                elif [[ "$keyword" == "group" && "$permission" == "execute" ]]; then
                       invert_group_execute_permission "$file"
		elif [[ "$keyword" == "other" && "$permission" == "write" ]]; then
                       invert_other_write_permission "$file"
		elif [[ "$keyword" == "other" && "$permission" == "read" ]]; then
                       invert_other_read_permission "$file"
		elif [[ "$keyword" == "other" && "$permission" == "execute" ]]; then
                       invert_other_execute_permission "$file"
                fi

      # Add the size to the total
     ((total_size += size))
    # Display the filename, size, and permissions after inversion
   echo "File: $file, Size: $size bytes, Owner : $(stat -c "%A" "$file" | cut -c 2-4)  , Group : $(stat -c "%A" "$file" | cut -c 5-7) , others : $(stat -c "%A" "$file" | cut -c 8-10) "

  fi
done

# Display the total size of all image files
echo "Total Image Size: $total_size bytes"

# Check the total size and display the appropriate message
if ((total_size < 5000000)); then
  echo "Total image size is small"
else
  echo "Total image size is NOT small"
fi

# Display the current date and time in DD-MM-YY:HH:mm format
current_datetime=$(date +'%d-%m-%y:%H:%M')
echo "Current Date and Time: $current_datetime"


#this script is for owner ( read , write , execute )
