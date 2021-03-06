#!/bin/bash

set -e


# xcodebuild -showsdks

xcodebuild -project DTCoreText.xcodeproj -target "Static Library" -configuration Release -sdk iphoneos build
xcodebuild -project DTCoreText.xcodeproj -target "Static Library" -configuration Release -sdk iphonesimulator build

cd Build
# for the fat lib file
mkdir -p Release-iphone/lib
xcrun -sdk iphoneos lipo -create Release-iphoneos/libDTCoreText.a Release-iphonesimulator/libDTCoreText.a -output Release-iphone/libDTCoreText.a
xcrun -sdk iphoneos lipo -info Release-iphone/libDTCoreText.a
# for header files
mkdir -p Release-iphone/DTCoreText
mkdir -p Release-iphone/DTFoundation
cp ../DTCoreText/*.h Release-iphone/DTCoreText
cp ../Externals/DTFoundation/DTFoundation/*.h Release-iphone/DTFoundation
