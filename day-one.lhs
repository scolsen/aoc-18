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
over our input list using monoidal addition (+)

We'll import...

We can use the `read` function to parse a string into some other type, in this
case int. Because we're taking a list of strings in this case, we'll write a
small partial function to map read to our list:

> mapRead :: [String] -> [Int]
> mapRead = map read

Our main program must read our input file into a list of strings, call our
mapRead function, and then fold over the result using summation.

> main = do
> 
>


