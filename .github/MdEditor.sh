cd App/
tuist generate
xcodebuild clean \
    -quiet \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditor' \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro'
