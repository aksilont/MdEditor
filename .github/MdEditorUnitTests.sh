xcodebuild test-without-building \
    -xctestrun $(find . -type f -name '*.xctestrun') \
    -scheme 'MdEditorTests' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
    -derivedDataPath 'DerivedData'