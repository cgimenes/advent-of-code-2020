(require '[clojure.string :as str]
         '[clojure.set :as set])

(def groups (str/split (slurp "input") #"\n\n"))

(def answer1 
    (->> groups
        (map (fn [x] (str/replace x #"\n" "")))
        (map distinct)
        (map count)
        (reduce +)))

(def answer2 
    (->> groups
        (map (fn [x] (str/split x #"\n")))
        (map (fn [x] (map set x)))
        (map (fn [x] (apply set/intersection x)))
        (map count)
        (reduce +)))

(do
    (println (str "Part 1: " answer1))
    (println (str "Part 2: " answer2)))