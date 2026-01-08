export const preset = 'ts-jest';
export const testEnvironment = 'node';
export const testMatch = ['**/*.test.ts'];
// Integration test requiring emulator
export const testPathIgnorePatterns = ['resize-image.test.ts'];
export const testTimeout = 10000;
export const collectCoverageFrom = ['src/**/*.ts', '!src/**/*.d.ts'];
export const coverageReporters = ['text', 'lcov'];
