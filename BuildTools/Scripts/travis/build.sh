mkdir build
cd build

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
  cmake .. -G "Unix Makefiles" $1 -DCMAKE_BUILD_TYPE=${CONFIG} &&
  cmake --build .
  # We must return now because otherwise the following if... command will reset the error code
  return
fi

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
  if [ "$IOS" = "true" ]; then
    cmake .. -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 -DVULKAN_SDK="$VULKAN_SDK" $1 -G "Xcode" || return
    XCODE_BUILD_SETTINGS="CODE_SIGNING_ALLOWED=NO"
  else
    cmake .. $1 -G "Xcode" || return
    XCODE_BUILD_SETTINGS=""
  fi
  xcodebuild -configuration ${CONFIG} ${XCODE_BUILD_SETTINGS} | xcpretty && return ${PIPESTATUS[0]}
fi
