
(setf *random-state* (make-random-state t))

(defun main()
  (defvar height 20)
  (defvar width  40)
  (defvar field (make-array `(,height ,width) :initial-contents
    (loop for i from 0 below height collecting
      (loop for j from 0 below width collecting (random 2)))))
  (loop
    (setf field (evolve field))
    (clear-screen)
    (dump-field field)
    (sleep 0.1)))

(defun evolve (field)
  (let* ((height  (array-dimension field 0))
         (width   (array-dimension field 1))
         (evolved (make-array `(,height ,width) :initial-element 0)))
    (dotimes (y height)
      (dotimes (x width)
        (let ((alive-neighbours 0))
          (loop for i from -1 to 1 do
            (loop for j from -1 to 1 do
              (if (not (and (= i 0) (= j 0)))
                (let ((y-i (mod (+ y i) height))
                      (x-i (mod (+ x j) width )))
                  (if (and (= 1 (aref field y-i x-i)))
                    (incf alive-neighbours))))))
          (setf (aref evolved y x)
                (cond ((<= alive-neighbours 1) 0)
                      ((=  alive-neighbours 2) (aref field y x))
                      ((=  alive-neighbours 3) 1)
                      ((>= alive-neighbours 4) 0))))))
    evolved))

(defun dump-field (field)
  (let ((height (array-dimension field 0))
        (width  (array-dimension field 1)))
    (dotimes (y height)
      (dotimes (x width)
        (format t "~a" (if (= 0 (aref field y x)) #\Space #\o)))
      (format t "~%")))
  field)

(defun clear-screen ()
  (format t "~A[H~@*~A[J" #\escape))

(main)
