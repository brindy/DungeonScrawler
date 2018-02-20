rm ./.build/x86_64-apple-macosx10.10/debug/DungeonScrawler
swift build
./.build/x86_64-apple-macosx10.10/debug/DungeonScrawler --seed "$@"
