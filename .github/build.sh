tuist generate -p App
xcodebuild clean -quiet
xcodebuild test \
    -workspace 'App/MdEditor.xcworkspace' \
    -scheme 'MdEditor' \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro' \
    test
