Advent of code 2018, day one.
Here's the problem statement:

"A value like +6 means the current frequency increases by 6; a value like -3
means the current frequency decreases by 3.

For example, if the device displays frequency changes of +1, -2, +3, +1, then
starting from a frequency of zero, the following changes would occur:

Current frequency  0, change of +1; resulting frequency  1.
Current frequency  1, change of -2; resulting frequency -1.
Current frequency -1, change of +3; resulting frequency  2.
Current frequency  2, change of +1; resulting frequency  3.

Starting with a frequency of zero, what is the resulting frequency after all of
the changes in frequency have been applied?"

Because our input contains signed numbers, we can use a fold to sum their
result. One solution entails simply reading each line of our input into a list, 
converting each string to a number while retaining its sign, and finally folding
over our input list using monoidal addition (+).

Folding is a common procedure:

< foldr (+) 0 x

We can use the `read` function to parse a string into some other type, in this
case Int. Because we're taking a list of strings, we'll use map to apply read to
each member of the list:

< map read

Now, read, unfortunately, doesn't know what to do with a '+' prefix. It handles
the '-' sign fine, but our numerals prefixed with '+' will result in an error.
So, we'll need an additional utility function to remove the '+' prefix.

> stripPos :: String -> String

We can use gaurds to check each of our numbers; if the head of the string is '+'
we return the rest of it using tail, otherwise, we just return the string:

> stripPos x  | '+' == head x = tail x
>             | otherwise     = x

Our main program must read our input file into a list of strings, read each as
an Int, and then fold over the result using summation.

> main = do
>   inputs     <- fmap lines (readFile "./inputs/day-one.txt")
>   normalized <- return $ map stripPos inputs
>   numbers    <- return $ map read normalized
>   result     <- return $ foldr (+) 0 numbers
>   print result

And viola, we get a result.
