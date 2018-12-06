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

After we generate our list of intermediate values, we can solve the problem by
finding the first member of the list that appears twice. In order to accomplish
this, we can first count the number of instances of each element in our
intermediate values list and produce a new list that contains a tuple of each
element and its count. We'll need a count function to count the number of
instances of the element and `zip` to zip our counts up with the element.

To count the number of elements in a list, we can filter the list to only those
elements, and then return the length of the resulting list:

> count x = length . filter (==x)

We can then explicitly map this function against our list of values and zip the
result together with our initial values:

> countEach xs = map (\x -> count x xs) xs

Then we zip

< let results = scanr (+) 0 inputs 
< let withCounts = zip results (countEach results)

We then simply take the first result that has a count of two.

< fst . head . filter ((>=2). snd) $ withCounts

Now, to our main program:

Part of the problem too, involves *continuing* processing the frequency if no initial input occurs twice.
We'll specify a recursive function for this purpose.

> scanner ::
>
> scanner g f z xs | g scn == [] = scanner g f (last scn) xs 
>                  | otherwise   = g scn 
>                  where scn = (scanl f z xs)

> getfreq :: [(a, a)] -> [a] -> a
>
> getfreq [] origin = getfreq (filter ((>=2) . snd)) 
>                   $ zip (scanl (+) (last origin) origin) (countEach origin)
>                   where rescan = scanl (+) (last scan) 
>

> getfreq [] ys = getfreq (filter ((>=2) . snd) 
>               $ zip (scanl (foldr (+) 0 ys) ys)) (countEach ys)
> getfreq xs _  = fst . head . xs  

> stripPos :: String -> String
> stripPos x  | '+' == head x = tail x
>             | otherwise     = x
>
> main = do
>   inputs     <- fmap lines (readFile "./inputs/day-one.txt")
>   normalized <- return $ map stripPos inputs
>   numbers    <- return $ map read normalized
>   answer     <- return $ getfreq [] numbers
>   print answer

That's it!
