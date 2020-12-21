# Programming Techniques

## Defensive Programming 

### DO use [assert](https://dart.dev/guides/language/language-tour#assert) to verify invariants 

The [style guide for the Flutter repo](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo#use-asserts-liberally-to-detect-contract-violations-and-verify-invariants) says to
> use-asserts-liberally-to-detect-contract-violations-and-verify-invariants


# Code Style 

### DO follow [Effective Dart: Style](https://dart.dev/guides/language/effective-dart/style)
- any parts of Effective Dart we don't follow will be added here 

### [DO format your code using dartfmt](https://dart.dev/guides/language/effective-dart/style#do-format-your-code-using-dartfmt) 

### CONSIDER using an extension to run dartfmt on save 
- see [Setup > IDEs](https://github.com/crowdleague/crowdleague/wiki/Setup#ides)

### DO Keep imports organised as per Effective Dart 

- [DO place “dart:” imports before other imports](https://dart.dev/guides/language/effective-dart/style#do-place-dart-imports-before-other-imports)
- [DO place “package:” imports before relative imports](https://dart.dev/guides/language/effective-dart/style#do-place-package-imports-before-relative-imports) 
- [DO specify exports in a separate section after all imports](https://dart.dev/guides/language/effective-dart/style#do-specify-exports-in-a-separate-section-after-all-imports)
- [DO sort sections alphabetically](https://dart.dev/guides/language/effective-dart/style#do-sort-sections-alphabetically)

### CONSIDER using an extension to auto organise imports 
- see [Setup > IDEs](https://github.com/crowdleague/crowdleague/wiki/Setup#ides)

### DO put every widget in a separate file
- using the folder structure to find the widget you want becomes a lot easier 

### DO collect widgets that are only used by a single composing widget into a folder with the composing widget's name 

### DO collect shared widgets in a folder called 'shared' 

### AVOID TODOs to `dev` 
- feel free to add TODOs as you work on a branch but create a issue rather than include a TODO when you make PR 

### AVOID unnecessary variables 
- where assigning an object does not add clarity and is not needed for accessing the object later, just declare the object where it is used 
  - eg. in widget tests, don't create an extra variable for AppState.init() 
- where an object doesn't take part in a test don't create one 
  - eg. set the reducer to null when creating a mock store in widget tests rather than use the appReducer 


# Markdown Style

Markdown should follow the default set of markdown lints defined in [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint).


# Contributing 

## PRs

### DO name PRs with issue number(s) and brief summary of what was done 

#### If the PR fixes issues name it as i<num>: What was done 
- keep "What was done" as short as possible while still making sense (so the commit history is as readable as possible)

### AVOID hiding changes in a sea of green 

#### Refactoring that includes file renames will hide your changes as every line in the file is now a new line.
Whenever possible, do a rename refactor in a separate PR.



# Tests 

## Naming (WIP) 

### Name Mocks as Mock 

- a class (eg. Store) that extends Mock → MockStore 
  - local variables that hold mocks → mockStore 

### Name test-double types with their purpose and variables with 'test' 

- name what the test double does, eg. StoreKeepsActions 
  - name local variables that hold other test doubles as (eg.) testStore 

## Widget Tests 

### DO have a single file for each widget being tested 

### DO name widget test files as `<widgetname>_test.dart` 

### DO have all tests in a single file under a group named ('<widgetname>') 

### DO use a test description that describes the behaviour being tested 
- such that if the test passes, the expected behaviour is what occurred 
- eg. 'updates switch when a positive data event arrives' 

### DO use a test description that completes a sentence starting with '\<widgetname\>' 
- in combination with the group name, the test description above will print: 
  - `<widgetname> updates switch when a positive data event arrives` 

### CONSIDER splitting up widget tests that change the app state 
- if a widget test changes the app state from the initial state, it might be an indication that the test could be split up into multiple tests 



# Architecture 

## Data classes 

#### Models, enums and actions should all be data classes 
- keep logic to the middleware & reducers
- converting to other types can be done with extensions 
- it's important we stick to this as we don't test any of the models, enums or actions (and the corresponding coverage info is not included) 

