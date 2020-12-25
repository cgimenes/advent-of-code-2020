(require '[clojure.string :as str]
         '[clojure.set :as set])

(def starting-numbers (map-indexed #(vector (Integer/parseInt %2) [%1]) (str/split (slurp "input") #",")))

(defn memory-game 
    [rc]
    (loop [i (dec (count starting-numbers))
           last (first (last starting-numbers))
           rounds (into {} starting-numbers)]
        (if (< i (dec rc))
            (let [new-i (inc i)
                  indexes (get rounds last)
                  new-diff (when (= (count indexes) 2) (apply - (reverse indexes)))
                  diff (vec (take-last 1 (get rounds new-diff [])))
                  zero (vec (take-last 1 (get rounds 0 [])))
                  new-round (if (< (count indexes) 2)
                                [0 (conj zero new-i)]
                                [new-diff (conj diff new-i)])]
                 (recur new-i (first new-round) (conj rounds new-round)))
            last)))

(def answer1 
    (memory-game 2020))

(def answer2
    (memory-game 30000000))

(do
    (println (str "Part 1: " answer1))
    (println (str "Part 2: " answer2)))