cd App
tuist generate
xcodebuild clean -quiet
xcodebuild test \
    -project 'MdEditor.xcodeproj' \
    -scheme 'MdEditor' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
    test
