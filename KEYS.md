# Keystore / key.properties (local setup)

Place your signing secrets in a `key.properties` file at the project root (or
`key.properties.windows` on Windows). This repo's Gradle script will:

- Load `key.properties.windows` when running on Windows (os.name contains "win").
- Load `key.properties` on macOS and Linux.
- If a properties file is present and `storeFile` points to a valid keystore,
  the release signing config will be populated automatically when building.
- If no properties file is present, release builds will fall back to the
  debug signing key locally so you can still run and iterate without changes.

Example `key.properties` (DO NOT COMMIT):

```
storeFile=keystores/my-release-key.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=YOUR_KEY_ALIAS
keyPassword=YOUR_KEY_PASSWORD
```

Notes:
- `storeFile` can be an absolute path or relative to the project root.
- Ensure the keystore file exists and the passwords/alias are correct; otherwise
  Gradle will fail the release build.
- This project adds `key.properties`, `key.properties.windows`, and `*.jks`
  to `.gitignore` by default to avoid accidentally committing secrets.

CI / automation:
- On CI, write a `key.properties` file before running the Gradle build step
  (use secrets in your CI provider) or configure signing via environment
  variables and a small setup script that writes the properties file.

Security:
- Keep keystore files and passwords secret. Rotate and revoke if leaked.

If you want, I can add a tiny Gradle/CI snippet that uses environment variables
instead of a properties file for safer CI integration.
