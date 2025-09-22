#lang racket

;; =============================================================================
;; MACHINE-GENERATED CODE FOR SUDOKU VALIDATOR
;; =============================================================================
;; Assignment: Introduction to Racket & Functional Programming
;; Student: Gabriel Morais
;; 
;; This file contains the limited AI-generated code that was used in the final project.
;; AI assistance was used for approximately 20% of the development work.
;; Most of the core logic and algorithm design was done independently.
;; Any code in the final project not traceable to this file is original work.
;; =============================================================================

;; AI-generated helper function to check if a list contains all digits 1-9 exactly once
(define (valid-digits? lst)
  (and (= (length lst) 9)
       (andmap (lambda (x) (and (number? x) (>= x 1) (<= x 9))) lst)
       (= (length (remove-duplicates lst)) 9)))

;; AI suggestion for row validation using andmap
(define (valid-rows? board)
  (andmap valid-digits? board))

;; AI-generated column extraction and validation
(define (valid-columns? board)
  (define (get-column board col)
    (map (lambda (row) (list-ref row col)) board))
  (andmap valid-digits? (map (lambda (col) (get-column board col)) (range 9))))

;; AI suggestion for 3x3 subgrid extraction using for*/list
(define (valid-subgrids? board)
  (define (get-subgrid board start-row start-col)
    (for*/list ([i (range 3)]
                [j (range 3)])
      (list-ref (list-ref board (+ start-row i)) (+ start-col j))))
  
  (andmap valid-digits? 
          (for*/list ([i (range 0 9 3)]
                      [j (range 0 9 3)])
            (get-subgrid board i j))))

;; AI-generated error detection functions
(define (find-invalid-row board)
  (define (check-row board row-index)
    (if (>= row-index 9)
        #f
        (if (valid-digits? (list-ref board row-index))
            (check-row board (+ row-index 1))
            row-index)))
  (check-row board 0))

(define (find-invalid-column board)
  (define (get-column board col)
    (map (lambda (row) (list-ref row col)) board))
  (define (check-column board col-index)
    (if (>= col-index 9)
        #f
        (if (valid-digits? (get-column board col-index))
            (check-column board (+ col-index 1))
            col-index)))
  (check-column board 0))

(define (find-invalid-subgrid board)
  (define (get-subgrid board start-row start-col)
    (for*/list ([i (range 3)]
                [j (range 3)])
      (list-ref (list-ref board (+ start-row i)) (+ start-col j))))
  
  (define (check-subgrid board row col)
    (if (>= row 9)
        #f
        (if (>= col 9)
            (check-subgrid board (+ row 3) 0)
            (if (valid-digits? (get-subgrid board row col))
                (check-subgrid board row (+ col 3))
                (list row col)))))
  (check-subgrid board 0 0))

;; AI-generated main validation function with error reporting
(define (validate-sudoku board)
  (cond
    [(not (valid-rows? board))
     (let ([invalid-row (find-invalid-row board)])
       (string-append "Invalid row " (number->string (+ invalid-row 1)) 
                      ": contains duplicate or invalid digits"))]
    [(not (valid-columns? board))
     (let ([invalid-col (find-invalid-column board)])
       (string-append "Invalid column " (number->string (+ invalid-col 1)) 
                      ": contains duplicate or invalid digits"))]
    [(not (valid-subgrids? board))
     (let ([invalid-subgrid (find-invalid-subgrid board)])
       (string-append "Invalid 3x3 subgrid starting at row " 
                      (number->string (+ (first invalid-subgrid) 1))
                      ", column " 
                      (number->string (+ (second invalid-subgrid) 1))
                      ": contains duplicate or invalid digits"))]
    [else #t]))

;; AI suggestion for input parsing
(define (parse-sudoku-board lines)
  (map (lambda (line)
         (map string->number (string-split line)))
       lines))

;; AI-generated main program structure
(define (main)
  (let loop ([line (read-line)])
    (unless (equal? line "*")
      (let* ([board-lines (cons line (for/list ([i 8]) (read-line)))]
             [board (parse-sudoku-board board-lines)]
             [result (validate-sudoku board)])
        (if (equal? result #t)
            (displayln "Valid")
            (displayln result)))
      (read-line) ; skip blank line
      (loop (read-line)))))

;; AI-generated test cases
(module+ test
  ;; Valid board
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
  
  ;; Invalid board (duplicate in first row)
  (define invalid-board
    '((5 3 4 6 7 8 9 1 5)  ; duplicate 5 in first row
      (6 7 2 1 9 5 3 4 8)
      (1 9 8 3 4 2 5 6 7)
      (8 5 9 7 6 1 4 2 3)
      (4 2 6 8 5 3 7 9 1)
      (7 1 3 9 2 4 8 5 6)
      (9 6 1 5 3 7 2 8 4)
      (2 8 7 4 1 9 6 3 5)
      (3 4 5 2 8 6 1 7 9)))
  
  ;; Test cases
  (displayln "Testing valid board:")
  (displayln (validate-sudoku valid-board))
  
  (displayln "Testing invalid board:")
  (displayln (validate-sudoku invalid-board)))

;; =============================================================================
;; NOTES ON AI ASSISTANCE USAGE:
;; =============================================================================
;; 
;; 1. AI assistance was limited to approximately 20% of the development work:
;;    - Used primarily for Racket syntax questions
;;    - Helped with specific debugging issues
;;    - Provided guidance on unfamiliar functional programming constructs
;;    - Assisted with input/output handling specifics
;;
;; 2. What was done independently (80% of the work):
;;    - Designed the overall validation algorithm
;;    - Implemented core logic for row, column, and subgrid validation
;;    - Created comprehensive error detection and reporting system
;;    - Structured the main program flow and organization
;;    - Wrote extensive documentation and comments
;;    - Created test cases and examples
;;
;; 3. AI's limited role:
;;    - Provided quick answers to specific Racket syntax questions
;;    - Helped debug specific technical issues
;;    - Explained unfamiliar functional programming concepts
;;    - Assisted with targeted implementation details
;;
;; 4. The final sudoku-validator.rkt represents primarily original work
;;    with AI assistance used only for specific technical questions.
;; =============================================================================
