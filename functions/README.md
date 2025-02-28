# CrowdLeague Firebase Functions

## Testing

### Locally

Start the emulators:

```sh
npm run build && firebase emulators:start --only storage,functions
```

Use one of the Jest configs in launch.json.

### Debugging

Start the emulators with `--inspect-functions`:

```sh
npm run build && firebase emulators:start --only functions,firestore,storage --inspect-functions
```

Run the "Debug Emulated Firebase Functions" config in launch.json.

We can run the jest tests with a debugger and debug the cloud function at the same time,
but the firebase emulator debugger must be attached again each time.
