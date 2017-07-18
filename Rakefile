def run(command)
  system(command) or raise "RAKE TASK FAILED: #{command}"
end

desc "Sets things up"
task :setup do |t|
  run "brew install carthage | true"
  run "gem install xcpretty | true"
  run "carthage bootstrap --cache-builds"
end

desc "Updates dependencies"
task :update do |t|
  run "carthage update --cache-builds"
end

namespace "test" do
  desc "Run unit tests for all iOS targets"
  task :ios do |t|
    `killall 'iOS Simulator'`
    run "set -o pipefail && xcodebuild -project Muon.xcodeproj -scheme MuonTests -destination 'platform=iOS Simulator,name=iPhone 6' test 2>/dev/null | xcpretty -c && echo 'Tests succeeded'"
  end

  desc "Run unit tests for all tvOS targets"
  task :tvos do |t|
    `killall 'tvOS Simulator'`
    run "set -o pipefail && xcodebuild -project Muon.xcodeproj -scheme MuonTests -destination 'platform=tvOS Simulator,name=Apple TV 1080p' test 2>/dev/null | xcpretty -c && echo 'Tests succeeded'"
  end

  desc "Run unit tests for all OS X targets"
  task :osx do |t|
    run "set -o pipefail && xcodebuild -project Muon.xcodeproj -scheme MuonTests test 2>/dev/null | xcpretty -c && echo 'Tests succeeded'"
  end
end

task default: ["setup", "test:ios", "test:tvos", "test:osx"]
