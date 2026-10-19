## Question 1: List Equality

### Question 1(a)

```
% Original lists

[truck, T, boat | [T, car, plane]]
[N | [boat, M | [P | Q]]]

% Standard notation

[truck, T, boat, T, car, plane]
[N, boat, M, P | Q]

% Terminal test

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

Matching corresponding elements gives `N = truck` and `T = boat`. Since `T` appears twice, both occurrences must equal `boat`, giving `M = P = boat`. The remaining elements form `Q = [car, plane]`. All assignments are consistent.

---

### Question 1(b)

```
% Original lists

[a, [M | [b, c]], d]
[a, [b, [b, c]] | T]

% Standard notation

[a, [M, b, c], d]
[a, [b, [b, c]] | T]

% Terminal test

[a, [M | [b, c]], d] =
[a, [b, [b, c]] | T].
```

**Result:** Unification fails.

**Explanation:**

The outer lists both begin with `a`, but their second elements have incompatible structures. `[M, b, c]` contains three elements, while `[b, [b, c]]` contains two. No assignment to `M` or `T` can make these nested lists identical.

---

### Question 1(c)

```
% Original lists

[X | [X | [[X | [[X]]]]]]
[b | M]

% Standard notation

[X, X, [X, [X]]]
[b | M]

% Terminal test

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

The first elements require `X = b`, so every occurrence of `X` becomes `b`. The remaining elements are assigned to the tail `M = [b, [b, [b]]]`, making both lists identical.

---

### Question 1(d)

```
% Original lists

[U | [W | [U]]]
[the, quick, brown, fox, W]

% Standard notation

[U, W, U]
[the, quick, brown, fox, W]

% Terminal test

[U | [W | [U]]] =
[the, quick, brown, fox, W].
```

**Result:** Unification fails.

**Explanation:**

The first list has three elements, while the second has five. Since neither list contains a variable tail, their lengths cannot change through unification. Therefore, the lists cannot be made identical.

---

### Question 1(e)

```
% Original lists

[Fox, [[in], socks], [on], box, on | [[knox]]]
[[The, cat], [[in], The], Hat | [Comes | Back]]

% Standard notation

[Fox, [[in], socks], [on], box, on, [knox]]
[[The, cat], [[in], The], Hat, Comes | Back]

% Terminal test

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

Matching corresponding elements gives `The = socks`, `Fox = [socks, cat]`, `Hat = [on]`, and `Comes = box`. The remaining elements form `Back = [on, [knox]]`. All assignments are consistent.

---

# Final Results

|Question|Unification|Variable Assignments / Reason|
|---|---|---|
|1(a)|Succeeds|`N=truck`, `T=boat`, `M=boat`, `P=boat`, `Q=[car,plane]`|
|1(b)|Fails|Incompatible nested list structures|
|1(c)|Succeeds|`X=b`, `M=[b,[b,[b]]]`|
|1(d)|Fails|Different fixed list lengths|
|1(e)|Succeeds|`The=socks`, `Fox=[socks,cat]`, `Hat=[on]`, `Comes=box`, `Back=[on,[knox]]`|