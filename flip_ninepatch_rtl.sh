#!/bin/bash

# Copyright 2015 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script takes as its input an existing 9-patch file for Left-to-Right
# layouts and converts it into a 9-patch file for Right-to-Left mode. This
# is done by horizontally flipping the image except the first and last columns,
# which need to remain in place to encode vertical stretching and padding.
#
# The script requires ImageMagick (or GraphicsMagick) to be installed and
# in the search path.

input=$1
output=$2

if [ ! -f ${input} ]; then
  echo "Input file ${input} does not exist."
  exit 1
fi

if [ -f ${output} ]; then
  echo "Output file ${output} already exists."
  exit 1
fi

size_xy=$(identify ${input} | sed 's/.*\ \([0-9]\+x[0-9]\+\) .*/\1/')
size_x=$(echo ${size_xy} | cut -dx -f1)
size_y=$(echo ${size_xy} | cut -dx -f2)

# Define the region specification for the entire image minus first and last
# columns. For example, for a 25x16 image, this will be 23x16+1+0.
region=$((size_x-2))x${size_y}+1+0

# Apply horizontal flip to the selected image region.
convert -region ${region} -flop ${input} ${output}
