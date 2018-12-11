Let's tackle part two of the day one problem. Here's the problem statement:

---

You notice that the device repeats the same frequency change list over and 
over. To calibrate the device, you need to find the first frequency it reaches twice.

For example, using the same list of changes above, the device would loop as follows:

Current frequency  0, change of +1; resulting frequency  1.
Current frequency  1, change of -2; resulting frequency -1.
Current frequency -1, change of +3; resulting frequency  2.
Current frequency  2, change of +1; resulting frequency  3.
(At this point, the device continues from the start of the list.)
Current frequency  3, change of +1; resulting frequency  4.
Current frequency  4, change of -2; resulting frequency  2, 
which has already been seen.
In this example, the first frequency reached twice is 2. 
Note that your device might need to repeat its list of frequency changes 
many times before a duplicate frequency is found, and that 
duplicates might be found while in the middle of processing the list.

---

The problem statement assumes we need to loop through the list a few times
before we can collect a repeat. Luckily, there's a functional idiom that solves
this problem gracefully: `scan`. Scan, which has left and right variants,
collects the intermediate results of applying a fold to a list of values. Thus,
scanning (+) 0 over [1, 2, 3]  results in a list: [0, 0 + 1, (0 + 1) + 2, ...].
We can use this function to generate a list of every intermediate value. We'll
read in inputs just as we did in part one of the problem.

We're not finished after we generate our list of intermediate values, however.
A number may not repeat in the first list of intermediates. As the problem
specifies, if that happens to be the case, we're to reapply the entire sequence
using the last frequency (the last element in our scan) as the first input.

This being the case, we need to establish a means of producing a continuous
list of sequential scans until a number repeats more than once in one of the 
scans. We can write a function to accomplish this:

> rescan :: (t -> t -> t) -> t -> [t] -> [[t]]
> rescan f z = iterate scan
>            where scan = last . scanl f z >>= scanl f

The rescan function iterates over scans, using the `last` value of the prior
scan as input to the next iteration. It produces an infinite list of scans.

Now that we have our infinite wealth of scans, we need to stop scanning once
we've solved the problem. In this case, our scans should cease once we've 
produced a scan that contains a value more than once. To accomplish this, we'll
need a means of counting the instances of the values in our scans. A simple 
count function will serve us just fine here.

> count :: Eq a => a -> [a] -> Int
> count x = length . filter (==x) 

Finally, we can set up a function that runs our scan iteration until the
condition we're looking for is satisfied:

> scanUntil :: ([t] -> Bool) -> (t -> t -> t) -> t -> [t] -> [t]
> scanUntil p f z = go . rescan f z 
>                 where go (x:xs) | p x       = x
>                                 | otherwise = go xs

Unfortunately, our scanUntil function returns the first element to satisfy a
given predicate, which is a list in this case. What we really need, however, 
is the number that satisfies our count predicate. In order to dig into our 
structure and pull out that grimy value, we'll have to map over counts, and 
discard any of the scan lists that don't result in a map with at least one member
that has a 2.

To map our count function, we can use a nice utility function rather than
explicitly write a lambda to count each member against the list:

> introspect :: Functor f => (a -> f a -> b) -> f a -> f b
> introspect f xs = fmap ff xs
>                 where ff = flip f xs . id

Introspect lets us write:

< introspect count [...]

Instead of having to write a lambda to map our count function against a list,
such as:

< countEach xs = map (\x -> count x xs) xs

The `any` function will let us verify whether or not the result of introspect
contains any count values greater than two. If so, that's the list we need.

< any (>2) . introspect count

We can name this modest composition:

> hasDuplicates :: Eq a => [a] -> Bool
> hasDuplicates = any (>=2) . introspect count

Our final scan solution is nice and tidy:

< scanUntil hasDuplicates (+) 0 inputs

Finally, we can write the complete solution:

> stripPos :: String -> String
> stripPos x  | '+' == head x = tail x
>             | otherwise     = x
>
> main = do
>   inputs     <- fmap lines (readFile "./inputs/day-one.txt")
>   normalized <- return $ map stripPos inputs
>   numbers    <- return $ map read normalized
>   scan       <- return $ scanUntil hasDuplicates (+) 0 numbers
>   counts     <- return $ zip (introspect count scan) scan
>   print counts

That's it!
