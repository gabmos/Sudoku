#!/bin/bash

echo "=== Sudoku Validator Test Suite ==="
echo

echo "Testing valid boards (should all show 'Valid'):"
for i in {1..6}; do
    echo -n "Test $i: "
    racket sudoku-validator.rkt < test$i.txt
done

echo
echo "Testing invalid boards (should all show error messages):"
for i in {7..12}; do
    echo -n "Test $i: "
    racket sudoku-validator.rkt < test$i.txt
done

echo
echo "=== Test Complete ==="
