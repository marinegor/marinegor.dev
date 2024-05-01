---
title: "Fast hex to np.ndarray"
date: "2023-04-25"
description: "Short story about transforming `chemfp` fingerprint representation into numpy ndarray"
tags:
  - numpy
  - til
  - python
---

# Hexadecimal string lists to np.ndarray, but fast

Say you have a list of strings, representing long binary arrays (say, 2048 bits), but represented in hexadecimal format:

```python
# compressed --> decompressed
01ab         --> [0,0,0,0, 0,0,0,1, 0,1,0,1, 0,1,1,0]
0001         --> [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0]
...          
00a0         --> [0,0,0,0, 0,0,0,0, 0,1,0,1, 0,0,0,0]
```

To say, a poors man's binary file. And you want to work with these arrays using `numpy`. To say, you want a function:

```python
def convert(s: str) -> np.ndarray:
    ... # do some magic

>>> s = '01ab'
>>> answ = np.array([0,0,0,0, 0,0,0,1, 0,1,0,1, 0,1,1,0])
>>> assert np.allclose(convert(s), answ)
```

If you have little experience and lots of patience, you'd write something like this:

```python
def convert_1_patience(s: str) -> np.ndarray:
    rv = ''
    for letter in s:
        if letter == '0':
            rv += '0000'
        elif letter == '1':
            rv += '0001'
        elif letter == '2':
            rv += '0010'
        elif letter == '3':
            rv += '0011'
        elif letter == '4':
            rv += '0100'
        elif letter == '5':
            rv += '0101'
        elif letter == '6':
            rv += '0110'
        elif letter == '7':
            rv += '0111'
        elif letter == '8':
            rv += '1000'
        elif letter == '9':
            rv += '1001'
        elif letter == 'a':
            rv += '1010'
        elif letter == 'b':
            rv += '1011'
        elif letter == 'c':
            rv += '1100'
        elif letter == 'd':
            rv += '1101'
        elif letter == 'e':
            rv += '1110'
        elif letter == 'f':
            rv += '1111'
    rv_int = []
    for letter in rv_str:
        rv_int.append(int(letter))
    return np.array(rv)
```

Which, in more idiomatic way and usage of builtins `int` and `bin` could be re-written as:

```python
def convert_2_builtins(s: str) -> np.ndarray:
    binarized = bin(int(s, 16))[2:].zfill(len(s)*4)
    return np.array([int(i) for i in binarized])
```

So far so good! Let's look how how it performs.
It should be noted that the strings aren't quite random -- they have some domain specifics. Namely, they're chemical fingerprints of molecules. Roughly, each bit represents whether a certain substructure is present in the molecule or not. So, I won't be testing the functions on purely random strings, but will take some real fingerprints -- 10k fingerprints, computed by wonderful `chemfp` package. Look like this:


```bash
$ head -n 10 my.fps
#FPS1
#num_bits=2048
#type=RDKit-Morgan/1 radius=2 fpSize=2048 useFeatures=0 useChirality=0 useBondTypes=1
#software=RDKit/2018.09.1 chemfp/1.6.1
#source=./split_0000001.txt
#date=2021-07-19T20:44:39
00420000000000000880014002000000000000000000001000000000000002000000000000000000000000000000008020000000080000100000000000000000000000000040020000000001000000000004000008108000000000000000000000000000800000000000000000000000000008000000000000000000000008000000000000000000010000000000000000000000080000000000000000000000000000000000000000000000100000000000000001100000000000000000000000000080000000000000000000000000000008000000000000024000000000000000000000000000000002000000002000000000000004008000108000000000    ZINC000000002166
00000000000000000000010000008000000000080000000000000000000000000000000020000000000000000000000020000000000000000000000000000000000000000000000010000000000000000010200000002000000000000100000000000000000000000000000000000200000000000000000000000000000000000000000002000000010000040000000000090000008000000000000800000000000008000000000000200000100000000000000000000000000000000000000000000000200000000000000000000000000800000000000000004200000080000000000000000000000002000000020000000080000100000000000000000400    ZINC000000007578
0040000000000000008000400000000000100000000000810000000000000202000000000000000000000000000000800000000008000000000000004000000000000000000000000000000000000000000400000800800000000400000040000000000080000000000a000000080000000008000000000000000000000000000000000002000000010000000000000001000000000000000000002000000000000000000000000000000000100000000000000000000000000000000000000001000080000000000000000000000000000020000000000000004000000000000000000100000000000002000000002000000000000004040000000000000000    ZINC000000031355
00000000000000000000000000000000000000000000008002000004000004000000000000000000000000000400000020000000000000400000000000000000000008000000000000000000000000000004000000000080000000000000000000000000800000000000000000000000000000c08000000000000000000000081000000000002000010000000000000001000000008000000000000000000000000000000020000000000000100080000000800000000000000100000000000000000000008000000001000000000000000000000000000020004000000000000000000100000000000002000000002000000000000000000000000000000000    ZINC000000032133
```

The file contains 10k fingerprints altogether -- it's a random sample of larger ZINC20 database, containing roughly 1 billion of molecules. So the reading speed of these fingerprints matters.

Let's run the benchmark though. Load the fingerprints:

```python
>>> with open('my.fps') as fin:
>>>     fps = [line.split()[0] for line in fin if not line.startswith('#')]
```

And run the benchmark. To be honest, the run on whole 10k fingerprints is terribly slow, so I cut it down to 10:

```python
>>>  %timeit -n 10 [convert_1_patience(s) for s in fps] 
3.75 ms ± 254 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)  
>>> %timeit -n 10 [convert_2_builtins(s) for s in fps]
3.5 ms ± 102 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```

Not much, isn't it? Extrapolating to 10k fingerprints, we get horrible 3 seconds for a single file. We can do much than that! In python, when you want to speed something up for multiple similar objects, your first good take is using numpy -- under the hood it uses super efficient Fortran, so the processor in turn will do all the fancy vectorization tricks with your objects.

Let's think how our function `convert` would look like. There are two complicated things in the function: converting string to integer, converting integer to several 1 and 0's, and iterating over the array. The last two steps combined could probably be done within numpy, since it's very good with numbers. And indeed, there is a function `np.unpackbits`, that does exactly what's needed -- uncompresses the representation of array of numbers into single bits:


```python
>>> a = [1,2,3]
>>> np.unpackbits(a)
TypeError: Expected an input array of unsigned byte data type
```

Well, that's reasonable -- for now, `a` contains integers of unknown size, thus numpy doesn't know how many bits per element the resulting array should have. Let's fix this using the smallest numpy integer type available:

```python
>>> a = np.array([1,2,3]).astype(np.uint8)
>>> np.unpackbits(a)
array([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
       1, 1], dtype=uint8)
```

The problem is, we now have twice as large array -- we wanted 4 elements per 1 symbol, and got 8. Let's fix this with reshaping in the final function:

```python
def convert_3_vectorized(s: str) -> np.ndarray:
    darr = [int(l, 16) for l in s]
    darr = np.array(darr).astype(np.uint8)
    darr = np.unpackbits(darr).reshape(-1,8)[:,4:].flatten()
    return darr
```

In the last line, we simply take last 4 bits of each number, since we're pretty sure that the first 4 bytest will be zeroes. Benchmarks:


```python
>>> %timeit -n 10 [convert_3_vectorized(s) for s in fps]  
1.17 ms ± 108 µs per loop (mean ± std. dev. of 7 runs, 10 loops each) 
```

Wow, that's 3 times improvement, not bad. Let's try a bit faster using lazy `np.fromiter` function instead of constructing a whole array:

```python
def convert_4_vectorized_iter(s: str) -> np.ndarray:
    darr = (int(l, 16) for l in s)
    darr = np.unpackbits(
        np.fromiter(darr, 
            dtype=np.int8)
        ).reshape(-1,8)[:,4:].flatten()
    return darr
```

The timing is basically similar:

```python
>>> %timeit -n 10 [convert_4_vectorized_iter(s) for s in fps]
1.06 ms ± 84 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```

Probably, at this moment the main bottleneck lays in converting strings into integers -- the builtin `int` function is good for arbitrary numbers, but we have a very specific domain, hexadecimal letters. In fact, this function has to work on 16 symbols only. In fact, we already wrote such a miracle in the very first function. Let's use it:

```python
def shortint(letter: str) -> int:
    if letter == '0':
        return 0
    elif letter == '1':
        return 1
    elif letter == '2':
        return 2
    elif letter == '3':
        return 3
    elif letter == '4':
        return 4
    elif letter == '5':
        return 5
    elif letter == '6':
        return 6
    elif letter == '7':
        return 7
    elif letter == '8':
        return 8
    elif letter == '9':
        return 9
    elif letter == 'a':
        return 10
    elif letter == 'b':
        return 11
    elif letter == 'c':
        return 12
    elif letter == 'd':
        return 13
    elif letter == 'e':
        return 14
    elif letter == 'f':
        return 15

def convert_5_shortint(s: str) -> np.ndarray:
    darr = (shortint(l) for l in s)
    darr = np.unpackbits(
        np.fromiter(darr, 
            dtype=np.uint8)
        ).reshape(-1,8)[:,4:].flatten()
    return darr
```

And the benchmark:

```python
>>> %timeit -n 10 [convert_5_shortint(s) for s in fps]
869 µs ± 161 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```
Ok, we're surprisingly getting somewhere! Although the function is super dumb and not idiomatic, it indeed gives some boost. 

Let's work further in this direction. Let's dream: it would be cool if we could simply use indexing instead of chain of `if ... elif` statements, and index some structure like `return struct[letter]`. Oh wait...

```python
def shortint_dict(l: str) -> int:
    struct = '01234567890abcdef'
    struct = {
        '0':0,
        '1':1, 
        '2':2, 
        '3':3, 
        '4':4, 
        '5':5, 
        '6':6, 
        '7':7, 
        '8':8, 
        '9':9, 
        'a':10,
        'b':11,
        'c':12,
        'd':13,
        'e':14,
        'f':15
    }
    return struct[letter]

def convert_6_shortint_dict(s: str) -> np.ndarray:
    darr = (shortint_dict(l) for l in s)
    darr = np.unpackbits(
        np.fromiter(darr, 
            dtype=np.uint8)
        ).reshape(-1,8)[:,4:].flatten()
    return darr
```

But the benchmarks aren't so happy about it:

```python
>>> %timeit -n 10 [convert_6_shortint_dict(s) for s in fps]
2.48 ms ± 386 µs per loop (mean ± std. dev. of 7 runs, 10 loops each) 
```

But wait a second: since python is dynamic, the function isn't precompiled in any way, but run every time dynamically from top to bottom, including the dict initialization. The solution to that would be to put the dictionary somewhere where it's computed only once. Although an experienced programmer would simply put it out of the function scope, I'd use a dirty hack here and put it as a function default parameter -- it's well known that default parameters are evaluated only once upon compilation to bytecode. So:

```python
def shortint_dict_default_cached(
    l: str,
    struct={
        "0": 0,
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        "a": 10,
        "b": 11,
        "c": 12,
        "d": 13,
        "e": 14,
        "f": 15,
    },
) -> int:
    return struct[l]


def convert_7_shortint_dict_cached(s: str) -> np.ndarray:
    darr = (shortint_dict_default_cached(l) for l in s)
    darr = (
        np.unpackbits(np.fromiter(darr, dtype=np.uint8))
        .reshape(-1, 8)[:, 4:]
        .flatten()
    )
    return darr
```

And the benchmarks are indeed happy about it:
```python
>>> %timeit -n 10 [convert_7_shortint_dict_cached(s) for s in fps]
936 µs ± 338 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```

Ok, not bad. But we still are kind of stuck around 1 ms per 10 fingerprints, which is still too much.

Let's agree that we've exsausted all the oportunities for internal letter-to-integer conversion in default python, and think about ways to do it in numpy. To do that, we need to understand what is a letter, internally. Turns out it's quite simple: int `utf-8` encoding (which we work in), all ASCII letters (meaning, not weird emojis or stuff) are represented by a single byte. In order to access these bytes, we can use a builtin function `bytes` or `bytearray`. In our case, it's convenient to use a `bytearray.fromhex` constructor:

```python
>>> s = '0123456789abcdef'
>>> bytearray.fromhex(s)
bytearray(b'\x01#Eg\x89\xab\xcd\xef')
>>> len(_), len(s)
(8, 16)
```

Note that the length has changed -- it's now two times shorter. That's because the `fromhex` constructor wants to create a byte from every two hex letters -- each of them representing 4 bits, 2*4=8 bits = 1 byte in total.

Let's now feed these bytes into numpy. Turns out there is a convenient `np.frombuffer` function that accepts a buffer-like object as a first argument (for example, the result of `bytearray.fromhex`), and a "encoding" parameter -- a numpy data type:

```python
>>> np.frombuffer(bytearray.fromhex(s), dtype=np.uint8)
array([  1,  35,  69, 103, 137, 171, 205, 239], dtype=uint8)
```

Which, after bit unpacking, turns into:
```python
>>> np.unpackbits(np.frombuffer(bytearray.fromhex(s), dtype=np.uint8)).reshape(-1,4) 
array([[0, 0, 0, 0],
       [0, 0, 0, 1],
       [0, 0, 1, 0],
       [0, 0, 1, 1],
       [0, 1, 0, 0],
       [0, 1, 0, 1],
       [0, 1, 1, 0],
       [0, 1, 1, 1],
       [1, 0, 0, 0],
       [1, 0, 0, 1],
       [1, 0, 1, 0],
       [1, 0, 1, 1],
       [1, 1, 0, 0],
       [1, 1, 0, 1],
       [1, 1, 1, 0],
       [1, 1, 1, 1]],
 dtype=uint8) 
```

Wow, that's the result we actually wanted! Turns out, although the resulting bytearray has halved length, a bit unpacking together with the right dtype gets the job done.

The resulting function turns out to be extremely simple then:

```python
def convert_8_frombuffer(s: str) -> np.ndarray: 
    return np.unpackbits(np.frombuffer(bytearray.fromhex(s), dtype=np.uint8))
```

And the benchmarks are as fast as you'd expect:

```python
>>> %timeit -n 10 [convert_8_frombuffer(s) for s in fps]
49.2 µs ± 1.58 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```
Wow, how cool is that! 20 times speed improvement by talking to the bits directly, without any conversion.

Finally, let's remember that we always want to convert the whole array of strings, not a single string. Namely, we want to have a function that accepts a list of strings, and returns a 2D `np.ndarray`. To date, we used a simple list comprehension (in benchmarks) to achieve that: 

```python
def convert_9_List(fps: List[str], converter=convert_8_frombuffer) -> np.ndarray:
    return np.array([converter(fp) for fp in fps])
```

The benchmarking code would change a bit as well:

```python
>>> %timeit -n 10 convert_9_List(fps)
59.5 µs ± 22.2 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```

Basically, the same time.

But... isn't the naive list comprehension something that we so successfully got rid of using numpy? It is indeed! Let's get rid of that -- concatenate all strings in the input list, and then run our fastest function on them:

```python
def convert_9_List_join(fps: List[str], converter=convert_8_frombuffer) -> np.ndarray:
    return converter(''.join(fps)).reshape(len(fps), -1)
```

Timing is slightly better:
```python
>>> %timeit -n 10 convert_10_List_join(fps) 
27.6 µs ± 8.19 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)  
```

But remember, we had a very large file. Let's try on an actual file indeed:

```python
>>> %timeit -n 10 convert_10_List_join(all_fps)
7.06 ms ± 634 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
>>> %timeit -n 10 convert_9_List(all_fps)
31.2 ms ± 909 µs per loop (mean ± std. dev. of 7 runs, 10 loops each)
```

Turns out our trick got us roughly 4 times more speed.
Full benchmark results:

```bash
Running convert_1_patience_L on arr length=10 in N=10
    mean time: 4478.0 us
     std time: 108.3 us
     min time: 4377.0 us
     max time: 4699.3 us
----------------------------------------
Running convert_2_builtins_L on arr length=10 in N=10
    mean time: 3396.3 us
     std time: 63.7 us
     min time: 3298.2 us
     max time: 3515.4 us
----------------------------------------
Running convert_3_vectorized_L on arr length=10 in N=10
    mean time: 1006.1 us
     std time: 11.8 us
     min time: 985.6 us
     max time: 1026.6 us
----------------------------------------
Running convert_4_vectorized_iter_L on arr length=10 in N=10
    mean time: 922.1 us
     std time: 14.7 us
     min time: 909.2 us
     max time: 959.3 us
----------------------------------------
Running convert_5_shortint_L on arr length=10 in N=10
    mean time: 609.1 us
     std time: 16.6 us
     min time: 586.8 us
     max time: 636.3 us
----------------------------------------
Running convert_6_shortint_dict_L on arr length=10 in N=10
    mean time: 2122.5 us
     std time: 53.3 us
     min time: 2025.8 us
     max time: 2242.1 us
----------------------------------------
Running convert_7_shortint_dict_cached_L on arr length=10 in N=10
    mean time: 634.0 us
     std time: 17.4 us
     min time: 608.5 us
     max time: 663.9 us
----------------------------------------
Running convert_8_frombuffer_L on arr length=10 in N=10
    mean time: 32.6 us
     std time: 3.4 us
     min time: 31.0 us
     max time: 42.6 us
----------------------------------------
Running convert_9_List on arr length=10 in N=10
    mean time: 24.2 us
     std time: 1.9 us
     min time: 23.1 us
     max time: 29.7 us
----------------------------------------
Running convert_10_List_join on arr length=10 in N=10
    mean time: 8.3 us
     std time: 1.1 us
     min time: 7.7 us
     max time: 11.5 us
----------------------------------------
Running convert_1_patience_L on arr length=10000 in N=10
    mean time: 4680224.7 us
     std time: 43320.8 us
     min time: 4601090.7 us
     max time: 4745800.8 us
----------------------------------------
Running convert_2_builtins_L on arr length=10000 in N=10
    mean time: 3977978.9 us
     std time: 608747.6 us
     min time: 3601444.1 us
     max time: 5657307.7 us
----------------------------------------
Running convert_3_vectorized_L on arr length=10000 in N=10
    mean time: 1132044.7 us
     std time: 80890.9 us
     min time: 1053527.9 us
     max time: 1334513.3 us
----------------------------------------
Running convert_4_vectorized_iter_L on arr length=10000 in N=10
    mean time: 977055.6 us
     std time: 35110.4 us
     min time: 925769.5 us
     max time: 1032194.9 us
----------------------------------------
Running convert_5_shortint_L on arr length=10000 in N=10
    mean time: 657414.1 us
     std time: 24327.4 us
     min time: 636385.1 us
     max time: 720548.2 us
----------------------------------------
Running convert_6_shortint_dict_L on arr length=10000 in N=10
    mean time: 2242470.6 us
     std time: 33085.9 us
     min time: 2186380.7 us
     max time: 2311272.5 us
----------------------------------------
Running convert_7_shortint_dict_cached_L on arr length=10000 in N=10
    mean time: 676429.0 us
     std time: 10639.6 us
     min time: 652150.7 us
     max time: 686811.7 us
----------------------------------------
Running convert_8_frombuffer_L on arr length=10000 in N=10
    mean time: 39407.0 us
     std time: 5706.7 us
     min time: 34884.7 us
     max time: 53128.1 us
----------------------------------------
Running convert_9_List on arr length=10000 in N=10
    mean time: 31637.2 us
     std time: 1273.1 us
     min time: 29342.5 us
     max time: 34028.8 us
----------------------------------------
Running convert_10_List_join on arr length=10000 in N=10
    mean time: 6841.7 us
     std time: 205.6 us
     min time: 6616.5 us
     max time: 7346.9 us
----------------------------------------
```

This whole thing gave us 700x performance over a naive implementation on both large files and single fingerprint strings.

Lessons learned (in order they appeared):
    - numpy vectorization helps
    - builtin functions give much shorter code
    - stupid functions with domain knowledge might overpower the builtins
    - numpy vectorization helps
    - to use that, you have to know the inner structure of your data
    - bytearrays are surprisingly nice
    - vectorization over vectorization helps
