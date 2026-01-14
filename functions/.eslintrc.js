module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
    tsconfigRootDir: __dirname,
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    "/generated/**/*", // Ignore generated files.
    "/coverage/**/*", // Ignore coverage reports.
  ],
  plugins: ["@typescript-eslint", "import"],
  rules: {
    quotes: "off",
    "object-curly-spacing": "off",
    "import/no-unresolved": 0,
    indent: "off",
    "quote-props": "off",
  },
  overrides: [
    {
      files: ["test/**/*.ts"],
      rules: {
        "@typescript-eslint/no-explicit-any": "off",
      },
    },
  ],
};
