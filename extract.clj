(require '[clojure.string :as str])

(def cut-off #"-----------------------------------------------------")

(defn split-reports
  [filename]
  (map str/trim 
       (filter #(and (not (str/blank? %))
                     (re-find #"Rolling" %))
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
                [#(re-find #"2016.*\d+:\d+:\d+\s*CST" %)]))

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

(def re-find-all
  (fn [re s]
    (let [matcher (re-matcher re s)
  )

(defn get-notes
  [report performance]
  (let [matcher (re-matcher #"NOTE:\s+(.*)" report)
        notes (loop [iter-notes [] 
                     getted (re-find matcher)]
                (if (nil? getted)
                  iter-notes
                  (recur (conj iter-notes (second getted))
                         (re-find matcher))))]
    (assoc performance :notes notes)))

(def get-notes
  (getter-maker [:notes]
                [(fn [r] (let [matcher (re-matcher #"NOTE:\s+(.*)" r)]
                           (loop [iter-notes [] 
                                  getted (re-find matcher)]
                             (if (nil? getted)
                               iter-notes
                               (recur (conj iter-notes (second getted))
                                      (re-find matcher))))))]))

(defn generate-performance
  [report]
  (->> {}
       (get-date report)
       (get-flags report)
       (get-matgen-dgefa-time report)
       (get-mflops report)
       (get-notes report)))

(def take-report (first raw-reports))
; (println (get-date take-report {}))
; (println (get-matgen-dgefa-time take-report {}))
; (println (get-flags take-report {}))
; (println (get-mflops take-report {}))
; (println (generate-performance take-report))
(println (get-notes take-report {}))

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
  (println "Notes:")
  (doall (map #(println %) (performance-report :notes)))
  (println ""))

(doall (map write-out extracted-reports))

