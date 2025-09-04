# Contributing to Retail Inventory Management System

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## Development Process

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

### Pull Requests Process

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

### Branch Naming Convention

- `feature/feature-name` for new features
- `bugfix/bug-name` for bug fixes
- `hotfix/critical-fix` for critical fixes
- `docs/documentation-update` for documentation updates

## Code Style

### Java/Spring Boot Backend

- Use standard Java naming conventions
- Follow Spring Boot best practices
- Include Javadoc comments for public methods
- Use meaningful variable and method names
- Maximum line length: 120 characters

```java
// Good
@GetMapping("/products/{id}")
public ResponseEntity<Product> getProductById(@PathVariable Long id) {
    // Implementation
}

// Bad
@GetMapping("/products/{id}")
public ResponseEntity<Product> getById(@PathVariable Long id) {
    // Implementation
}
```

### Frontend (HTML/CSS/JavaScript)

- Use 2-space indentation
- Use meaningful CSS class names
- Follow ES6+ JavaScript standards
- Use const/let instead of var
- Use arrow functions where appropriate

```javascript
// Good
const loadProducts = async () => {
    try {
        const response = await fetch(`${API_BASE_URL}/products`);
        const products = await response.json();
        displayProducts(products);
    } catch (error) {
        console.error('Error loading products:', error);
    }
};

// Bad
function loadProducts() {
    fetch(API_BASE_URL + '/products').then(function(response) {
        return response.json();
    }).then(function(products) {
        displayProducts(products);
    });
}
```

### VBA Code

- Use descriptive variable names
- Include error handling
- Add comments for complex logic
- Use consistent indentation

```vba
' Good
Public Function GetProducts() As String
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    ' Implementation
    
ErrorHandler:
    MsgBox "Error: " & Err.Description
End Function
```

## Testing

### Backend Tests

Run tests before submitting:

```bash
cd backend
mvn test
```

Write unit tests for new functionality:

```java
@Test
public void testGetProductById_ShouldReturnProduct_WhenProductExists() {
    // Arrange
    Long productId = 1L;
    Product expected = new Product();
    when(productRepository.findById(productId)).thenReturn(Optional.of(expected));
    
    // Act
    ResponseEntity<Product> response = productController.getProductById(productId);
    
    // Assert
    assertEquals(HttpStatus.OK, response.getStatusCode());
    assertEquals(expected, response.getBody());
}
```

### Frontend Tests

Test JavaScript functions manually in the browser console and ensure all features work as expected.

### Integration Tests

Test the complete flow:
1. Database operations
2. API endpoints
3. Frontend interactions
4. Excel VBA integration

## Database Changes

When making database schema changes:

1. Update `schema.sql`
2. Update `sample_data.sql` if needed
3. Update corresponding entity classes
4. Add migration notes in the PR description

## Documentation

Update documentation when making changes:

- Update README.md for new features
- Update API_DOCUMENTATION.md for API changes
- Update SETUP.md for installation changes
- Add inline code comments for complex logic

## Issue Reporting

### Bug Reports

Use the bug report template:

**Bug Description**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior.

**Expected Behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment**
- OS: [e.g. Windows 10]
- Java Version: [e.g. 11]
- Browser: [e.g. Chrome 91]
- MySQL Version: [e.g. 8.0.25]

### Feature Requests

Use the feature request template:

**Is your feature request related to a problem?**
A clear description of what the problem is.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Any alternative solutions or features you've considered.

**Additional context**
Any other context or screenshots about the feature request.

## Security Issues

**DO NOT** create a public GitHub issue for security vulnerabilities.

Instead, email security concerns to [security@yourcompany.com](mailto:security@yourcompany.com).

## Code Review Process

All submissions require review before merging:

1. At least one approving review from a maintainer
2. All CI checks must pass
3. No conflicts with the target branch
4. Documentation updated if necessary

### Review Criteria

- Code follows style guidelines
- Changes are tested
- Documentation is updated
- Commit messages are clear
- No breaking changes (or properly documented)

## Commit Message Format

Use conventional commits format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Formatting, missing semicolons, etc
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding tests
- `chore`: Changes to build process or auxiliary tools

Examples:
```
feat(api): add product search endpoint
fix(frontend): resolve dashboard loading issue
docs: update API documentation
```

## Development Setup

1. Follow the [SETUP.md](docs/SETUP.md) guide
2. Create a `.env` file with development settings
3. Run the application locally
4. Test your changes thoroughly

## Questions?

Feel free to ask questions by:
- Creating a GitHub issue with the `question` label
- Starting a discussion in GitHub Discussions
- Reaching out to maintainers directly

## Code of Conduct

By participating, you are expected to uphold our Code of Conduct:

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment include:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or discriminatory comments
- Publishing private information without permission
- Any conduct that could reasonably be considered inappropriate

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the Retail Inventory Management System! 🎉
