(require '[clojure.string :as str])

(def cut-off #"-----------------------------------------------------")

(defn split-reports
  [filename]
  (filter #(and (not (empty? %)) 
                (re-find #"Rolling" %))
          (map str/trim 
               (str/split (slurp filename) cut-off))))

(def raw-reports (split-reports "Linpack.txt"))

(defn getter-maker
  [assoc-keys extractors]
  (fn [report performance]
    (merge performance 
           (zipmap assoc-keys
                   (map #(% report) extractors)))))

(def get-date 
  (getter-maker [:date]
                [#(re-find #"^.*\d+:\d+:\d+\s*CST" %)]))

(def get-flags 
  (getter-maker [:flags]
                [#(second (re-find #"FLAGS: (.*)" %))]))

(def get-matgen-dgefa-time
  (getter-maker [:matgen :matgen-dgefa]
                [#(second (re-find #"160000 times ([\.\d]+) seconds" %))
                 #(second (re-find #"16000 times ([\.\d]+) seconds" %))]))

(defn get-mflops
  [report performance]
  (let [matcher (re-matcher #"Average\s+([\.\d]+)" report)]
    (assoc performance
           :mflops201 (second (re-find matcher))
           :mflops200 (second (re-find matcher)))))

(def get-notes 
  (getter-maker [:notes]
                [#(map second (re-seq #"NOTE:\s+(.*)" %))]))

(def get-type
  (getter-maker [:program-type]
                [#(second (re-find #"TYPE:\s+(.*)" %))]))

;(defn generate-performance
;  [report]
;  (->> {}
;       (get-date report)
;       (get-flags report)
;       (get-matgen-dgefa-time report)
;       (get-mflops report)
;       (get-notes report)))

(defn generate-performance
  [report]
  ;(reduce (fn [results f] (f report results))
  (reduce #(%2 report %1) {}
          [get-date
           get-flags
           get-matgen-dgefa-time
           get-mflops
           get-notes
           get-type]))

(def take-report (first raw-reports))
; (println (get-date take-report {}))
; (println (get-matgen-dgefa-time take-report {}))
; (println (get-flags take-report {}))
; (println (get-mflops take-report {}))
; (println (generate-performance take-report))
; (println (get-notes take-report {}))

(def extracted-reports (map generate-performance raw-reports))

(defn write-out
  [{:keys [date program-type flags matgen matgen-dgefa mflops201 mflops200 notes]}]
  (println "Date:              " date)
  (println "Program type:      " program-type)
  (println "Flags:             " flags)
  (println "160k matgen:       " matgen)
  (println "16k matgen-dgefa:  " matgen-dgefa)
  (println "Mflops 201:        " mflops201)
  (println "Mflops 200:        " mflops200)
  (println "Notes:")
  (doall (map println notes))
  (println))

(doall (map write-out extracted-reports))

