## Unreleased
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [0.2.0] - 2018-03-14
### Added
- Added `spec/acceptance/support` directory. It contains test harness to use the .rule files from standard SRL test suite. 
- Added `acceptance/srl_test_suite_spec.rb`file. Spec file designed to standard SRL test suite. At this date, SrlRuby passes 3 tests out of 15 tests in total.

### Changed
- API Change. Method SrlRuby#parse returns a Regexp instance (previously it was a String)
- API Change. Method SrlRuby#load_file returns a Regexp instance (previously it was a String)

### Fixed
- SRL 'backslash' produces now 4 consecutive backslashes (required by the conversion into Regexp)

## [0.1.1] - 2018-03-10
### Changed
- Parse error location is now given in line number, column number position.
- Updated dependencies upon Rley parser.

## [0.1.0] - 2018-03-08
### Added
- Version bump. Added new API methods `SrlRuby#load_file` and `SrlRuby#parse`

### Changed
- File `README.md` vastly improved with examples and usage snippet.

## [0.0.2] - 2018-03-07
### Added
- File `CHANGELOG.md`. This file. Adopting `keepachangelog.com` recommended format.
- File `appveyor.yml`. Configuration file for the AppVeyor CI (automated builds on Windows)

### Changed
- File `README.md` added badges (Appveyor build status, Gem version, license)

## [0.0.1] - 2018-03-06
### Added
- Initial working Github commit

