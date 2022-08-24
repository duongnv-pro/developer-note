<!-- @format -->

# Python Tutorial

- [Back](../README.md)

#### Chapter 1 - Number
Phép toán nâng cao
```py
min(1,2,3,4)
1
max(1,2,3,4)
4
abs(-123)
123
```

```py
import math

math.sqrt(25)
5.0
math.factorial(3)
6
math.ceil(4.1)
4
math.floor(4.6)
5
```
#### Chapter 2 - String
```py
s = "I love \"Python 3\""

Multi line using """

s = """ Day la dau
  Toi lai ai"""
```
So sánh giá trị: ==, <, >, >=, <=
Kiểm tra kiểu đổi tượng: is
```py
x = 4
y = 4
x is y
True
```
Kiểm tra nằm trong dãy ký tự: in
```py
A = [1, 4, 5, 6]
5 in A
True
```
#### Chapter 3 - Container Object
+ Tuples ()
+ Lists [ ]
+ Sets { }
+ Dictionaries { }
```py
tup = (1, 2, 4, 5)
tup = ("day", "la", "dau")
list = ["tao", "la", "ai"]
s = {3, 1, 2, 6}
# Set sẽ tự động sắp xếp
1, 2, 3, 4
dic = {"n1": "Ai do le", "n2": "Mecury"}
```
#### Chapter 4 - Assignment Operators
```py
x = x + 5         x += 5
x = x ** 2        x **= 2
math.ceil(x/3)    x //= 3
x = x << 3 (x * 3 * 3)        x <<= 3
x = x >> 3 (x / 3 / 3)        x >>= 3
```
##### Conditionals
If Statement
```py
if true :
  print("Hello")
```
If else Statement
```py
if x > y :
  print(x, " lon hon ", y)
else :
  print(x, " be hon ", y)
```
If elif else Statement
```py
if x > y :
  print(x, " lon hon ", y)
elif x == y and True :
  print(x, " bang ", y)
else :
  print(x, " be hon ", y)
```
##### While Loop
```py
n = 1
while (n <= 10) :
  print(n, end = ' ')
  n += 1
```
##### For Loop
```py
t = (1, 3, 4, 5, 7, 2)
for n in t :
  print(n, end = " ")

d = {'email': 'loli', 'age': 17}
for key in d :
  print(d[key], end = ' ')
```
### Continue - Break

