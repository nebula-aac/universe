# @module-federation/bridge-shared

## 0.17.1

### Patch Changes

- a7cf276: chore: upgrade NX to 21.2.3, Storybook to 9.0.9, and TypeScript to 5.8.3

  - Upgraded NX from 21.0.3 to 21.2.3 with workspace configuration updates
  - Migrated Storybook from 8.3.5 to 9.0.9 with updated configurations and automigrations
  - Upgraded TypeScript from 5.7.3 to 5.8.3 with compatibility fixes
  - Fixed package exports and type declaration paths across all packages
  - Resolved module resolution issues and TypeScript compatibility problems
  - Updated build configurations and dependencies to support latest versions

- d31a326: refactor: sink React packages from root to individual packages

  - Removed React dependencies from root package.json and moved them to packages that actually need them
  - Fixed rsbuild-plugin configuration to match workspace patterns
  - Updated tests to handle platform-specific files
  - This change improves dependency management by ensuring packages only have the dependencies they actually use

## 0.17.0

## 0.16.0

## 0.15.0

## 0.14.3

## 0.14.2

## 0.14.1

## 0.14.0

### Patch Changes

- 677aac9: vue.js has router option added to the vue3-bridge

## 0.13.1

## 0.13.0

### Patch Changes

- 38f324f: Disable live bindings on cjs builds of the runtime packages

## 0.12.0

## 0.11.4

## 0.11.3

## 0.11.2

## 0.11.1

## 0.11.0

## 0.10.0

## 0.9.1

## 0.9.0

## 0.8.12

## 0.8.11

## 0.8.10

## 0.8.9

## 0.8.8

## 0.8.7

## 0.8.6

## 0.8.5

## 0.8.4

## 0.8.3

## 0.8.2

## 0.8.1

## 0.8.0

## 0.7.7

## 0.7.6

## 0.7.5

## 0.7.4

## 0.7.3

## 0.7.2

## 0.7.1

## 0.7.0

### Minor Changes

- 3942740: add license information

## 0.6.16

## 0.6.15

## 0.6.14

### Patch Changes

- ad605d2: chore: unified logger

## 0.6.13

## 0.6.12

## 0.6.11

## 0.6.10

## 0.6.9

## 0.6.8

## 0.6.7

## 0.6.6

## 0.6.5

## 0.6.4

## 0.6.3

## 0.6.2

## 0.6.1

## 0.6.0

## 0.5.2

## 0.5.1

## 0.5.0

### Patch Changes

- 49d6135: feat(@module-federation/bridge): enhance Bridge capabilities and fix some issues

## 0.4.0

## 0.3.5

## 0.3.4

## 0.3.3

## 0.3.2

## 0.3.1

## 0.3.0

## 0.2.8

## 0.2.7

## 0.2.6

## 0.2.5

## 0.2.4

## 0.2.3

## 0.2.2

## 0.2.1

## 0.2.0

### Minor Changes

- d2ab821: feat(bridge): Supports exporting and loading of application-level modules (with routing), currently supports react and vue3
