cd App/
tuist generate
xcodebuild test \
    -quiet \
    -workspace 'MdEditor.xcworkspace' \
    -scheme 'MdEditorTests' \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 14 Pro'
