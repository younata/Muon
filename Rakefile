def run(command)
  system(command) or raise "RAKE TASK FAILED: #{command}"
end

namespace "test" do
  desc "Run unit tests for all iOS targets"
  task :ios do |t|
    `killall 'iOS Simulator'`
    run "set -o pipefail && xcodebuild -project Muon.xcodeproj -scheme MuonTests -destination 'platform=iOS Simulator,name=iPhone 6' clean test 2>/dev/null | xcpretty -c && echo 'Tests succeeded'"
  end

  desc "Run unit tests for all OS X targets"
  task :osx do |t|
    run "set -o pipefail && xcodebuild -project Muon.xcodeproj -scheme Muon-OSXTests test 2>/dev/null | xcpretty -c && echo 'Tests succeeded'"
  end
end

task default: ["test:ios", "test:osx"]
