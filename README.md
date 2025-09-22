# Sudoku Validator

A Racket program that validates 9x9 Sudoku boards according to the standard Sudoku rules.

## Files

- `sudoku-validator.rkt` - Main Racket source code
- `test1.txt` through `test12.txt` - Test cases (1-6 valid, 7-12 invalid)
- `test-all.sh` - Test script to run all test cases
- `ai-prompts.txt` - Documentation of AI prompts used
- `machine-generated-code.rkt` - Copy of all AI-generated code
- `references.txt` - List of online references used

## How to Run

### Prerequisites
- Racket must be installed (can be installed via `brew install racket` on macOS)

### Running the Program
```bash
# Run with a single test file
racket sudoku-validator.rkt < test1.txt

# Run all tests
./test-all.sh
```

### Input Format
The program expects input in the following format:
- 9 lines, each containing 9 single digits separated by whitespace
- A blank line
- An asterisk (*) to mark the end of input

### Output
- `Valid` - if the Sudoku board is valid
- Error message - if the board is invalid, describing the first issue found

## Validation Rules

The program checks that:
1. Each digit 1-9 appears exactly once in each row
2. Each digit 1-9 appears exactly once in each column  
3. Each digit 1-9 appears exactly once in each 3x3 subgrid

## Test Cases

- **test1.txt - test6.txt**: Valid Sudoku boards
- **test7.txt - test12.txt**: Invalid Sudoku boards with various errors

## Development

This project was developed as part of a Racket/Functional Programming assignment. The code follows functional programming principles and uses Racket's built-in list operations and higher-order functions.
