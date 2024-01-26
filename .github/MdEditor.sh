cd App/
tuist generate
xcodebuild clean build-for-testing \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditor' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
    -derivedDataPath 'DerivedData'