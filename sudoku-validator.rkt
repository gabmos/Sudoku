#lang racket

;; =============================================================================
;; SUDOKU VALIDATOR - FUNCTIONAL PROGRAMMING ASSIGNMENT
;; =============================================================================
;; Author: [Student Name]
;; Course: Introduction to Racket & Functional Programming
;; Assignment: Sudoku Board Validation
;;
;; This program validates 9x9 Sudoku boards according to the standard rules:
;; 1. Each digit from 1 to 9 appears exactly once in each row
;; 2. Each digit from 1 to 9 appears exactly once in each column
;; 3. Each digit from 1 to 9 appears exactly once in each 3x3 subgrid
;;
;; The program reads input from standard input in the specified format:
;; - 9 lines, each containing 9 single digits separated by whitespace
;; - A blank line separating puzzles
;; - An asterisk (*) marking the end of input
;;
;; For invalid boards, the program reports the first error found with
;; specific location information (row, column, or subgrid).
;; =============================================================================

;; -----------------------------------------------------------------------------
;; HELPER FUNCTIONS
;; -----------------------------------------------------------------------------

;; valid-digits? : (listof number) -> boolean
;; Determines if a list contains exactly the digits 1-9 with no duplicates
;; This is the core validation function used by all other validators
;;
;; Preconditions: lst is a list of numbers
;; Postconditions: Returns #t if lst has exactly 9 unique numbers in range 1-9
;;                 Returns #f otherwise
;;
;; Examples:
;; (valid-digits? '(1 2 3 4 5 6 7 8 9)) -> #t
;; (valid-digits? '(1 2 3 4 5 6 7 8 1)) -> #f (duplicate 1)
;; (valid-digits? '(0 1 2 3 4 5 6 7 8)) -> #f (contains 0)
(define (valid-digits? lst)
  (and (= (length lst) 9)                                    ; Must have exactly 9 elements
       (andmap (lambda (x) (and (number? x) (>= x 1) (<= x 9))) lst)  ; All elements must be numbers 1-9
       (= (length (remove-duplicates lst)) 9)))              ; Must have 9 unique elements (no duplicates)

;; -----------------------------------------------------------------------------
;; ROW VALIDATION
;; -----------------------------------------------------------------------------

;; valid-rows? : (listof (listof number)) -> boolean
;; Validates that all rows in the Sudoku board contain exactly the digits 1-9
;; with no duplicates in any row
;;
;; Preconditions: board is a 9x9 list of lists representing the Sudoku board
;; Postconditions: Returns #t if all rows are valid, #f otherwise
;;
;; Strategy: Use andmap to apply valid-digits? to each row
;; This leverages functional programming by treating validation as a mapping operation
(define (valid-rows? board)
  (andmap valid-digits? board))  ; Apply valid-digits? to each row in the board

;; -----------------------------------------------------------------------------
;; COLUMN VALIDATION
;; -----------------------------------------------------------------------------

;; valid-columns? : (listof (listof number)) -> boolean
;; Validates that all columns in the Sudoku board contain exactly the digits 1-9
;; with no duplicates in any column
;;
;; Preconditions: board is a 9x9 list of lists representing the Sudoku board
;; Postconditions: Returns #t if all columns are valid, #f otherwise
;;
;; Strategy: Extract each column as a list, then validate each column
;; This demonstrates functional programming by using map to transform the board
;; structure and then applying validation to the transformed data
(define (valid-columns? board)
  ;; Helper function to extract a specific column from the board
  ;; get-column : (listof (listof number)) number -> (listof number)
  (define (get-column board col)
    (map (lambda (row) (list-ref row col)) board))  ; Extract col-th element from each row
  
  ;; Apply get-column to each column index (0-8), then validate each column
  (andmap valid-digits? (map (lambda (col) (get-column board col)) (range 9))))

;; -----------------------------------------------------------------------------
;; SUBGRID VALIDATION
;; -----------------------------------------------------------------------------

;; valid-subgrids? : (listof (listof number)) -> boolean
;; Validates that all 3x3 subgrids in the Sudoku board contain exactly the digits 1-9
;; with no duplicates in any subgrid
;;
;; Preconditions: board is a 9x9 list of lists representing the Sudoku board
;; Postconditions: Returns #t if all subgrids are valid, #f otherwise
;;
;; Strategy: Extract each 3x3 subgrid as a flat list, then validate each subgrid
;; This demonstrates advanced functional programming with nested for loops
;; and list comprehensions
(define (valid-subgrids? board)
  ;; Helper function to extract a 3x3 subgrid starting at given coordinates
  ;; get-subgrid : (listof (listof number)) number number -> (listof number)
  (define (get-subgrid board start-row start-col)
    (for*/list ([i (range 3)]                    ; Iterate through 3 rows
                [j (range 3)])                   ; Iterate through 3 columns
      (list-ref (list-ref board (+ start-row i)) (+ start-col j))))  ; Extract cell value
  
  ;; Generate all 9 subgrids by starting at positions (0,0), (0,3), (0,6),
  ;; (3,0), (3,3), (3,6), (6,0), (6,3), (6,6)
  (andmap valid-digits? 
          (for*/list ([i (range 0 9 3)]          ; Start rows: 0, 3, 6
                      [j (range 0 9 3)])         ; Start columns: 0, 3, 6
            (get-subgrid board i j))))

;; -----------------------------------------------------------------------------
;; ERROR DETECTION FUNCTIONS
;; -----------------------------------------------------------------------------
;; These functions find the first occurrence of invalid data in each category
;; They are used to provide specific error messages to the user

;; find-invalid-row : (listof (listof number)) -> (union #f number)
;; Finds the first invalid row in the Sudoku board and returns its 0-based index
;; Returns #f if all rows are valid
;;
;; Preconditions: board is a 9x9 list of lists representing the Sudoku board
;; Postconditions: Returns 0-based index of first invalid row, or #f if all valid
;;
;; Strategy: Use tail recursion to check rows sequentially until finding an invalid one
;; This demonstrates functional programming with recursive iteration
(define (find-invalid-row board)
  ;; Internal helper function that does the actual checking
  ;; check-row : (listof (listof number)) number -> (union #f number)
  (define (check-row board row-index)
    (if (>= row-index 9)                                    ; Base case: checked all rows
        #f                                                   ; All rows are valid
        (if (valid-digits? (list-ref board row-index))      ; Check if current row is valid
            (check-row board (+ row-index 1))               ; Recursive case: check next row
            row-index)))                                     ; Found invalid row, return its index
  (check-row board 0))                                      ; Start checking from row 0

;; find-invalid-column : (listof (listof number)) -> (union #f number)
;; Finds the first invalid column in the Sudoku board and returns its 0-based index
;; Returns #f if all columns are valid
;;
;; Preconditions: board is a 9x9 list of lists representing the Sudoku board
;; Postconditions: Returns 0-based index of first invalid column, or #f if all valid
;;
;; Strategy: Extract each column and check it sequentially using tail recursion
(define (find-invalid-column board)
  ;; Helper function to extract a specific column (reused from valid-columns?)
  (define (get-column board col)
    (map (lambda (row) (list-ref row col)) board))
  
  ;; Internal helper function that checks columns sequentially
  ;; check-column : (listof (listof number)) number -> (union #f number)
  (define (check-column board col-index)
    (if (>= col-index 9)                                    ; Base case: checked all columns
        #f                                                   ; All columns are valid
        (if (valid-digits? (get-column board col-index))    ; Check if current column is valid
            (check-column board (+ col-index 1))            ; Recursive case: check next column
            col-index)))                                     ; Found invalid column, return its index
  (check-column board 0))                                   ; Start checking from column 0

;; find-invalid-subgrid : (listof (listof number)) -> (union #f (list number number))
;; Finds the first invalid 3x3 subgrid in the Sudoku board and returns its coordinates
;; Returns #f if all subgrids are valid
;;
;; Preconditions: board is a 9x9 list of lists representing the Sudoku board
;; Postconditions: Returns (list row col) of first invalid subgrid, or #f if all valid
;;
;; Strategy: Check subgrids in row-major order using nested tail recursion
(define (find-invalid-subgrid board)
  ;; Helper function to extract a 3x3 subgrid (reused from valid-subgrids?)
  (define (get-subgrid board start-row start-col)
    (for*/list ([i (range 3)]
                [j (range 3)])
      (list-ref (list-ref board (+ start-row i)) (+ start-col j))))
  
  ;; Internal helper function that checks subgrids in row-major order
  ;; check-subgrid : (listof (listof number)) number number -> (union #f (list number number))
  (define (check-subgrid board row col)
    (if (>= row 9)                                          ; Base case: checked all subgrid rows
        #f                                                   ; All subgrids are valid
        (if (>= col 9)                                      ; Check if we need to move to next row
            (check-subgrid board (+ row 3) 0)               ; Move to next row of subgrids
            (if (valid-digits? (get-subgrid board row col)) ; Check if current subgrid is valid
                (check-subgrid board row (+ col 3))         ; Recursive case: check next subgrid
                (list row col)))))                           ; Found invalid subgrid, return coordinates
  (check-subgrid board 0 0))                                ; Start checking from subgrid (0,0)

;; -----------------------------------------------------------------------------
;; MAIN VALIDATION FUNCTION
;; -----------------------------------------------------------------------------

;; validate-sudoku : (listof (listof number)) -> (union #t string)
;; Main validation function that checks a Sudoku board and returns either #t for valid
;; or a descriptive error message for the first error found
;;
;; Preconditions: board is a 9x9 list of lists representing the Sudoku board
;; Postconditions: Returns #t if board is valid, or error message string if invalid
;;
;; Strategy: Check rows first, then columns, then subgrids (as specified in assignment)
;; This ensures we report the first error found in the order specified
;;
;; Error Message Format: "Invalid [type] [location]: contains duplicate or invalid digits"
;; where [type] is "row", "column", or "3x3 subgrid"
;; and [location] is the 1-based index or coordinates
(define (validate-sudoku board)
  (cond
    ;; Check rows first - if any row is invalid, report the first invalid row
    [(not (valid-rows? board))
     (let ([invalid-row (find-invalid-row board)])
       (string-append "Invalid row " (number->string (+ invalid-row 1)) 
                      ": contains duplicate or invalid digits"))]
    
    ;; Check columns second - if any column is invalid, report the first invalid column
    [(not (valid-columns? board))
     (let ([invalid-col (find-invalid-column board)])
       (string-append "Invalid column " (number->string (+ invalid-col 1)) 
                      ": contains duplicate or invalid digits"))]
    
    ;; Check subgrids last - if any subgrid is invalid, report the first invalid subgrid
    [(not (valid-subgrids? board))
     (let ([invalid-subgrid (find-invalid-subgrid board)])
       (string-append "Invalid 3x3 subgrid starting at row " 
                      (number->string (+ (first invalid-subgrid) 1))
                      ", column " 
                      (number->string (+ (second invalid-subgrid) 1))
                      ": contains duplicate or invalid digits"))]
    
    ;; If all checks pass, the board is valid
    [else #t]))

;; -----------------------------------------------------------------------------
;; INPUT PARSING FUNCTIONS
;; -----------------------------------------------------------------------------

;; parse-sudoku-board : (listof string) -> (listof (listof number))
;; Converts a list of strings (each representing a row) into a 9x9 board structure
;; Each string should contain 9 space-separated digits
;;
;; Preconditions: lines is a list of 9 strings, each containing 9 space-separated digits
;; Postconditions: Returns a 9x9 list of lists representing the Sudoku board
;;
;; Strategy: Use map to transform each line string into a list of numbers
;; This demonstrates functional programming by treating parsing as a mapping operation
(define (parse-sudoku-board lines)
  (map (lambda (line)
         (map string->number (string-split line)))  ; Split line by spaces and convert to numbers
       lines))

;; process-sudoku-board : -> (union #t string)
;; Reads a single Sudoku board from standard input and validates it
;; This function is used for testing individual boards
;;
;; Preconditions: Standard input contains 9 lines of 9 space-separated digits each
;; Postconditions: Returns validation result (#t or error message)
(define (process-sudoku-board)
  (let* ([lines (for/list ([i 9]) (read-line))]     ; Read 9 lines from input
         [board (parse-sudoku-board lines)])        ; Parse lines into board structure
    (validate-sudoku board)))                       ; Validate the board

;; -----------------------------------------------------------------------------
;; MAIN PROGRAM
;; -----------------------------------------------------------------------------

;; main : -> void
;; Main program that reads multiple Sudoku boards from standard input until
;; an asterisk (*) is encountered, validating each board and printing results
;;
;; Input Format:
;; - Multiple Sudoku puzzles, each consisting of:
;;   - 9 lines of 9 space-separated digits
;;   - A blank line separating puzzles
;; - An asterisk (*) marking the end of input
;;
;; Output: For each board, prints either "Valid" or an error message
;;
;; Strategy: Use tail recursion with a loop to process multiple boards
;; This demonstrates functional programming with recursive iteration
(define (main)
  (let loop ([line (read-line)])                    ; Read first line
    (unless (equal? line "*")                       ; Continue until we see asterisk
      (let* ([board-lines (cons line (for/list ([i 8]) (read-line)))]  ; Read remaining 8 lines
             [board (parse-sudoku-board board-lines)]                  ; Parse into board structure
             [result (validate-sudoku board)])                         ; Validate the board
        (if (equal? result #t)                      ; Check if board is valid
            (displayln "Valid")                     ; Print "Valid" for valid boards
            (displayln result)))                    ; Print error message for invalid boards
      (read-line)                                   ; Skip blank line between puzzles
      (loop (read-line)))))                         ; Recursive call to process next puzzle

;; -----------------------------------------------------------------------------
;; MODULE EXECUTION
;; -----------------------------------------------------------------------------

;; When this file is run directly, execute the main function
;; This allows the program to be run from the command line
(module+ main
  (main))

;; -----------------------------------------------------------------------------
;; TEST MODULE
;; -----------------------------------------------------------------------------
;; This module contains test cases and examples for the Sudoku validator
;; It demonstrates the functionality of the program with both valid and invalid boards

(module+ test
  ;; Example of a valid Sudoku board
  ;; This board satisfies all Sudoku rules:
  ;; - Each row contains digits 1-9 exactly once
  ;; - Each column contains digits 1-9 exactly once  
  ;; - Each 3x3 subgrid contains digits 1-9 exactly once
  (define valid-board
    '((5 3 4 6 7 8 9 1 2)
      (6 7 2 1 9 5 3 4 8)
      (1 9 8 3 4 2 5 6 7)
      (8 5 9 7 6 1 4 2 3)
      (4 2 6 8 5 3 7 9 1)
      (7 1 3 9 2 4 8 5 6)
      (9 6 1 5 3 7 2 8 4)
      (2 8 7 4 1 9 6 3 5)
      (3 4 5 2 8 6 1 7 9)))
  
  ;; Example of an invalid Sudoku board
  ;; This board has a duplicate '5' in the first row (positions 1 and 9)
  ;; This violates the row constraint and should be detected
  (define invalid-board
    '((5 3 4 6 7 8 9 1 5)  ; duplicate 5 in first row (positions 1 and 9)
      (6 7 2 1 9 5 3 4 8)
      (1 9 8 3 4 2 5 6 7)
      (8 5 9 7 6 1 4 2 3)
      (4 2 6 8 5 3 7 9 1)
      (7 1 3 9 2 4 8 5 6)
      (9 6 1 5 3 7 2 8 4)
      (2 8 7 4 1 9 6 3 5)
      (3 4 5 2 8 6 1 7 9)))
  
  ;; Run test cases and display results
  ;; This demonstrates the program's ability to distinguish between valid and invalid boards
  (displayln "=== SUDOKU VALIDATOR TEST CASES ===")
  (displayln)
  
  (displayln "Testing valid board:")
  (displayln (validate-sudoku valid-board))
  (displayln)
  
  (displayln "Testing invalid board:")
  (displayln (validate-sudoku invalid-board))
  (displayln)
  
  (displayln "=== TEST COMPLETE ==="))
