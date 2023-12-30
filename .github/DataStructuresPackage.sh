tuist fetch
tuist generate
xcodebuild clean -quiet
xcodebuild test \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'DataStructuresPackageTests' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
    test
