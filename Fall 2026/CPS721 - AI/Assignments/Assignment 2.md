# CPS721 — Assignment 2

## Question 1: List Equality

### Objective

Determine whether each pair of Prolog lists can be made identical through unification. Convert the lists to standard notation, identify variable assignments, and explain the result.

---
### Question 1(a)

**Original lists:**

```
[truck, T, boat | [T, car, plane]]
[N | [boat, M | [P | Q]]]
```

**Standard notation:**

```
[truck, T, boat, T, car, plane]
[N, boat, M, P | Q]
```

**Terminal test:**

```
[truck, T, boat, T, car, plane] =
[N, boat, M, P | Q].
```

**Result:** Unification succeeds.

**Variable assignments:**

```
N = truck
T = boat
M = boat
P = boat
Q = [car, plane]
```

**Explanation:**

The first elements require `N = truck`, while the second elements require `T = boat`. Since `T` appears again in the fourth position, the fourth element must also be `boat`. The third and fourth elements determine `M = boat` and `P = boat`. Finally, `Q = [car, plane]` represents the remaining elements. All assignments are consistent, so the lists can be made identical.

---
### Question 1(b)

**Original lists:**

```
[a, [M | [b, c]], d]
[a, [b, [b, c]] | T]
```

**Standard notation:**

```
[a, [M, b, c], d]
[a, [b, [b, c]] | T]
```

**Terminal test:**

```
[a, [M | [b, c]], d] =
[a, [b, [b, c]] | T].
```

**Result:** Unification fails.

**Explanation:**

Both outer lists begin with `a`, so the first elements match. However, their second elements have incompatible structures. The first nested list is `[M, b, c]`, containing three elements, while the second is `[b, [b, c]]`, containing two elements. Although `M` could match `b`, the remaining elements would require the atom `b` to match the nested list `[b, c]`. Since these structures differ, unification fails regardless of the value of `T`.

---
### Question 1(c)

**Original lists:**

```
[X | [X | [[X | [[X]]]]]]
[b | M]
```

**Standard notation:**

```
[X, X, [X, [X]]]
[b | M]
```

**Terminal test:**

```
[X | [X | [[X | [[X]]]]]] =
[b | M].
```

**Result:** Unification succeeds.

**Variable assignments:**

```
X = b
M = [b, [b, [b]]]
```

**Explanation:**

The first elements require `X = b`. Because `X` occurs repeatedly, every occurrence must take the same value, including those inside the nested lists. The first list therefore becomes `[b, b, [b, [b]]]`. The second list already begins with `b`, and its tail variable `M` can represent all remaining elements. Assigning `M = [b, [b, [b]]]` makes both lists identical.

---
### Question 1(d)

**Original lists:**

```
[U | [W | [U]]]
[the, quick, brown, fox, W]
```

**Standard notation:**

```
[U, W, U]
[the, quick, brown, fox, W]
```

**Terminal test:**

```
[U | [W | [U]]] =
[the, quick, brown, fox, W].
```

**Result:** Unification fails.

**Explanation:**

The first list contains three elements, while the second contains five. Although matching the first two elements would require `U = the` and `W = quick`, the remaining list structures cannot match. Both `U` and `W` occupy individual element positions rather than tail positions, so assigning values to them cannot change the outer list lengths. Therefore, the lists cannot be made identical.

---
### Question 1(e)

**Original lists:**

```
[Fox, [[in], socks], [on], box, on | [[knox]]]
[[The, cat], [[in], The], Hat | [Comes | Back]]
```

**Standard notation:**

```
[Fox, [[in], socks], [on], box, on, [knox]]
[[The, cat], [[in], The], Hat, Comes | Back]
```

**Terminal test:**

```
[Fox, [[in], socks], [on], box, on | [[knox]]] =
[[The, cat], [[in], The], Hat | [Comes | Back]].
```

**Result:** Unification succeeds.

**Variable assignments:**

```
The = socks
Fox = [socks, cat]
Hat = [on]
Comes = box
Back = [on, [knox]]
```

**Explanation:**

The first elements require `Fox = [The, cat]`. Comparing the second elements, `[[in], socks]` and `[[in], The]`, gives `The = socks`, making `Fox = [socks, cat]`. The third elements require `Hat = [on]`, while the fourth elements give `Comes = box`. Finally, the tail `Back` must equal `[on, [knox]]`. All variable assignments are consistent, so both lists unify successfully.

---
### Final Results

|Question|Unification|Variable Assignments|
|---|---|---|
|1(a)|Succeeds|`N=truck`, `T=boat`, `M=boat`, `P=boat`, `Q=[car,plane]`|
|1(b)|Fails|Incompatible nested lists|
|1(c)|Succeeds|`X=b`, `M=[b,[b,[b]]]`|
|1(d)|Fails|Different fixed list lengths|
|1(e)|Succeeds|`The=socks`, `Fox=[socks,cat]`, `Hat=[on]`, `Comes=box`, `Back=[on,[knox]]`|
