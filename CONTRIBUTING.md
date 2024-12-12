# Contributing to EllipseFitAllignment

Thank you for your interest in contributing to the EllipseFitAllignment project! We welcome your suggestions, improvements, and new features. Please follow the guidelines below to ensure a smooth collaboration process.

***

## How to Contribute

### 1. Fork the Repository

-   Start by forking the repository to your GitHub account.
-   Clone your forked repository to your local machine:

```bash
git clone https://github.com/your-username/EllipseFitAllignment.git
```

### 2. Create a Feature Branch

-   Create a branch for your changes:

```bash
git checkout -b feature/your-feature-name
```

### 3. Make Changes

-   Implement your changes, ensuring they follow the coding standards outlined below.
-   Add comments to explain the purpose and functionality of your modifications.
-   Test your changes thoroughly on example datasets like `Kimia99_DB` or `TARI_DB`.

### 4. Submit a Pull Request

-   Push your changes to your forked repository:

```bash
git push origin feature/your-feature-name
```

-   Open a pull request to the main repository and include:
    -   A clear title for the pull request.
    -   A detailed description of the changes made and the problem they address.

***

## Coding Standards

### General Guidelines

-   **Consistency**: Use consistent indentation and formatting.
-   **Modularity**: Write reusable and modular code by breaking functionality into functions.
-   **Comments**: Add meaningful comments to describe the purpose of each function, its inputs, outputs, and any assumptions.

### MATLAB Standards

-   Use descriptive variable and function names.
-   Avoid hardcoding values; use parameters or variables where possible.
-   Include error handling to prevent unexpected crashes.

***

## Testing Guidelines

-   Test your contributions on smaller datasets to validate functionality.
-   Verify:
    -   Training outputs (e.g., `bw_train` and `vr_train`) are correctly computed.
    -   Test results (e.g., `num_rec` and `assignment_matrix`) are accurate and consistent.
-   If your changes affect visualization, ensure plots and outputs are clear and informative.

***

## Reporting Issues

-   If you encounter any problems or have suggestions, open an issue in the repository.
-   Include:
    -   A clear and concise title.
    -   A detailed description of the issue, including steps to reproduce it.
    -   Relevant error messages, screenshots, or logs.

***

## Documentation Updates

-   If you add or modify functionality, ensure the `README.md` file reflects these changes.
-   Provide examples for new features where applicable.

***

## Suggestions for Contributions

-   Optimize the code for performance (e.g., parallel processing, memory management).
-   Add support for non-binary image formats.
-   Expand visualization tools for more detailed insights.

***

## Contact

For further assistance, you can reach out to the maintainers via:

-   **Email**: [prresearch26@gmail.com](mailto:prresearch26@gmail.com)
-   **GitHub Issues**: [Open an Issue](https://github.com/your-repo/EllipseFitAllignment/issues)

Thank you for contributing!
