# GitHub Copilot Instructions for FutureOn K8s Integration Template

This document provides guidelines for GitHub Copilot when assisting with this project.

## Project Overview

This is a Kubernetes integration template project with:
- Svelte 5 frontend with runes (in `/frontends/svelte/`)
- Node.js backend (in `/backends/nodejs/`)
- Helm charts for Kubernetes deployment (in `/helm/integration/`)

## Code Style and Conventions

### General Conventions

- Use camelCase for variables and functions
- Use PascalCase for component names, classes, and constructors
- Use kebab-case for file names
- Maximum line length: 100 characters
- Use 2 spaces for indentation
- Use single quotes for strings
- Always use semicolons
- Prefer const over let, avoid var
- Add trailing commas in multiline objects and arrays

### JavaScript/Node.js Conventions

- Use ES6+ features where appropriate
- Use async/await instead of Promise chains when possible
- Use destructuring for objects and arrays
- Use template literals instead of string concatenation
- Export functions and classes at the end of the file
- Use named exports over default exports

### Svelte Conventions

- This project uses Svelte 5 with the runes API
- Use the `$state()`, `$derived()`, and `$effect()` runes for state management
- Prefer runes over Svelte's older reactive syntax (`$:`) when possible
- Use `$props()` for component props definition
- Use `$derived()` for computed values
- Use `$effect()` for side effects
- Keep components small and focused on a single responsibility
- Use Svelte's built-in state management before reaching for stores
- Put component-specific styles in the same .svelte file
- Use event handlers with runes syntax

### Svelte 5 Runes Examples

```javascript
// State declaration
const count = $state(0);

// Props declaration
const { title = 'Default Title', onAction } = $props();

// Derived values
const doubled = $derived(count * 2);

// Effects
$effect(() => {
  console.log(`Count changed to: ${count}`);
});

// Event handling
function handleClick() {
  count++;
}
```

## JSDoc Documentation

All functions, classes, and methods should be documented using JSDoc with the following format:

```javascript
/**
 * Brief description of the function/class/method
 *
 * @param {Type} paramName - Description of the parameter
 * @param {Type} [optionalParam] - Description of the optional parameter
 * @returns {ReturnType} Description of the return value
 * @throws {ErrorType} Description of when this error is thrown
 * @example
 * // Example usage of the function/class/method
 * const result = myFunction('example');
 */
```

## Project Structure

### Frontend (Svelte)

- Components should be placed in the `/frontends/svelte/src/components/` directory
- API services should be placed in the `/frontends/svelte/src/actions/` directory
- Store files should be placed in the `/frontends/svelte/src/stores/` directory
- Utility functions should be placed in the `/frontends/svelte/src/utils/` directory

### Backend (Node.js)

- Route handlers should be placed in the `/backends/nodejs/routes/` directory
- Business logic should be placed in the `/backends/nodejs/src/` directory
- Middleware should be placed in the `/backends/nodejs/middleware/` directory
- Integration with FutureOn services should be handled in `/backends/nodejs/src/fieldtwin.js`

## Testing

- Backend tests should be placed in a `/backends/nodejs/tests/` directory
- Frontend tests should be placed in a `/frontends/svelte/tests/` directory
- Write tests for all new features
- Follow the AAA pattern (Arrange, Act, Assert) for test structure

## Logging

- Use the custom logger in `/backends/nodejs/src/logger.js` for backend logging
- Log appropriate information at the correct log level (error, warn, info, debug)
- Don't log sensitive information

## API Design

- Follow RESTful principles for API endpoints
- Use consistent naming conventions for endpoints
- Document all API endpoints

## Kubernetes and Helm

- Follow Kubernetes best practices when modifying Helm templates
- Document any changes to the Helm chart values
- Ensure resource limits and requests are set appropriately

## Security Considerations

- Sanitize all user inputs
- Use HTTPS for all external communications
- Don't hardcode credentials or secrets
- Use environment variables for configuration

## Performance Considerations

- Minimize the number of API calls
- Implement appropriate caching mechanisms
- Use pagination for large data sets
- Optimize frontend assets for production

## When Adding New Dependencies

- Discuss major dependencies before adding them
- Document why a new dependency is needed
- Keep dependencies up to date
- Consider the size and maintenance status of dependencies

## Deployment

- Backend and frontend are deployed as separate services in Kubernetes
- Ingress is configured for both services
- The project uses Tilt for local development