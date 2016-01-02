(require '[clojure.string :as str])

(def cut-off #"-----------------------------------------------------")

(defn split-reports
  [filename]
  (filter #(not (str/blank? %))
          (str/split (slurp filename) cut-off)))

(def raw-reports (split-reports "Linpack.txt"))

(defn get-date
  [report performance]
  (let [date (re-find #"2016.*\d+:\d+:\d+\s*CST" report)]
    (assoc performance :date date)))

(defn get-flags
  [report performance]
  (let [flags (second (re-find #"FLAGS: (.*)"
                               report))]
    (assoc performance
           :flags flags)))

(defn get-matgen-dgefa-time
  [report performance]
  (let [matgen (second (re-find #"160000 times ([\.\d]+) seconds" 
                                report))
        matgen-dgefa (second (re-find #"16000 times ([\.\d]+) seconds" 
                                      report))]
    (assoc performance 
           :matgen matgen
           :matgen-dgefa matgen-dgefa)))

(defn get-mflops
  [report performance]
  (let [matcher (re-matcher #"Average\s+([\.\d]+)" report)
        mflops201 (second (re-find matcher))
        mflops200 (second (re-find matcher))]
    (assoc performance
           :mflops201 mflops201
           :mflops200 mflops200)))

(defn generate-performance
  [report]
  (->> {}
       (get-date report)
       (get-flags report)
       (get-matgen-dgefa-time report)
       (get-mflops report)))


(def take-report (first raw-reports))
;(println (get-date take-report {}))
;(println (get-matgen-dgefa-time take-report {}))
;(println (get-flags take-report {}))
;(println (get-mflops take-report {}))
;(println (generate-performance take-report))

(def extracted-reports (filter #(:matgen %)
                                  (map generate-performance raw-reports)))

(defn write-out
  [performance-report]
  (println "Date:              " (performance-report :date))
  (println "Flags:             " (performance-report :flags))
  (println "160k matgen:       " (performance-report :matgen))
  (println "16k matgen-dgefa:  " (performance-report :matgen-dgefa))
  (println "Mflops 201:        " (performance-report :mflops201))
  (println "Mflops 200:        " (performance-report :mflops200))
  (println ""))

(doall (map write-out extracted-reports))
