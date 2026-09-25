# Manual Decision Tree

## Training Data

| x1 | x2 | y |
|---:|---:|:--:|
| 0 | 0 | T |
| 0 | 0 | T |
| 1 | 0 | T |
| 1 | 0 | T |
| 0 | 1 | F |
| 0 | 1 | F |
| 1 | 1 | T |
| 1 | 2 | T |
| 0 | 2 | F |
| 1 | 2 | F |

---

## Q1 — Entropy

**Question:** What is the entropy of this collection of training examples with respect to the target class?

There are:

- `T = 6`
- `F = 4`
- Total = `10`

Therefore:

$$
P(T)=\frac{6}{10}=0.6
$$

$$
P(F)=\frac{4}{10}=0.4
$$

Entropy:

$$
H(S)=-P(T)\log_2P(T)-P(F)\log_2P(F)
$$

$$
H(S)=-(0.6)\log_2(0.6)-(0.4)\log_2(0.4)
$$

$$
H(S)\approx0.971
$$

**Answer:**

$$
\boxed{H(S)=0.971}
$$

---

## Q2 — Possible First Splits

**Question:** What are the different options for the first split?

Because the tree must be binary:

1. `x1 = 0` vs. `x1 = 1`
2. `x2 <= 0` vs. `x2 > 0`
3. `x2 <= 1` vs. `x2 > 1`

---

## Q3 — Information Gain

Information gain is:

$$
IG(S,A)=H(S)-H(S|A)
$$

where:

$$
H(S|A)
=
\frac{|S_1|}{|S|}H(S_1)
+
\frac{|S_2|}{|S|}H(S_2)
$$

### Split 1 — `x1`

For `x1 = 0`:

- `T = 2`
- `F = 3`

$$
H(x1=0)
=
-\frac25\log_2\frac25
-\frac35\log_2\frac35
\approx0.971
$$

For `x1 = 1`:

- `T = 4`
- `F = 1`

$$
H(x1=1)
=
-\frac45\log_2\frac45
-\frac15\log_2\frac15
\approx0.722
$$

Weighted entropy:

$$
H(S|x1)
=
\frac5{10}(0.971)
+
\frac5{10}(0.722)
$$

$$
H(S|x1)\approx0.846
$$

Information gain:

$$
IG(x1)
=
0.971-0.846
=
\boxed{0.125}
$$

---

### Split 2 — `x2 <= 0`

For `x2 <= 0`:

- `T = 4`
- `F = 0`

$$
H(x2\le0)=0
$$

For `x2 > 0`:

- `T = 2`
- `F = 4`

$$
H(x2>0)
=
-\frac26\log_2\frac26
-\frac46\log_2\frac46
\approx0.918
$$

Weighted entropy:

$$
H(S|x2\le0)
=
\frac4{10}(0)
+
\frac6{10}(0.918)
$$

$$
H(S|x2\le0)\approx0.551
$$

Information gain:

$$
IG(x2\le0)
=
0.971-0.551
=
\boxed{0.420}
$$

---

### Split 3 — `x2 <= 1`

For `x2 <= 1`:

- `T = 5`
- `F = 2`

$$
H(x2\le1)
=
-\frac57\log_2\frac57
-\frac27\log_2\frac27
\approx0.863
$$

For `x2 > 1`:

- `T = 1`
- `F = 2`

$$
H(x2>1)
=
-\frac13\log_2\frac13
-\frac23\log_2\frac23
\approx0.918
$$

Weighted entropy:

$$
H(S|x2\le1)
=
\frac7{10}(0.863)
+
\frac3{10}(0.918)
$$

$$
H(S|x2\le1)\approx0.880
$$

Information gain:

$$
IG(x2\le1)
=
0.971-0.880
=
\boxed{0.091}
$$

### Results

| Split | Information Gain |
|---|---:|
| `x1 = 0` vs. `x1 = 1` | `0.125` |
| `x2 <= 0` vs. `x2 > 0` | **`0.420`** |
| `x2 <= 1` vs. `x2 > 1` | `0.091` |

Therefore the best root split is:

$$
\boxed{x2\le0}
$$

---

## Q4 — Complete Decision Tree

### Step 1 — Root

Choose `x2 <= 0` because it has the highest information gain:

$$
IG=0.420
$$

For `x2 <= 0`:

$$
T=4,\quad F=0
$$

There are only 4 instances, so the node cannot be split.

Prediction:

$$
\boxed{T}
$$

For `x2 > 0`:

$$
T=2,\quad F=4
$$

There are 6 instances, so this node can be split.

---

### Step 2 — Split `x2 > 0`

`x2` cannot be used again on the same path, so use `x1`.

For `x1 = 0`:

$$
T=0,\quad F=3
$$

Only 3 instances remain, so this becomes:

$$
\boxed{F}
$$

For `x1 = 1`:

$$
T=2,\quad F=1
$$

Only 3 instances remain, so use the majority class:

$$
\boxed{T}
$$

---

## Final Decision Tree

```mermaid
flowchart TD
    A["x2 <= 0?<br/>T=6, F=4"]
    A -->|Yes| B["T<br/>T=4, F=0"]
    A -->|No| C["x1 = 0?<br/>T=2, F=4"]
    C -->|Yes| D["F<br/>T=0, F=3"]
    C -->|No| E["T<br/>T=2, F=1"]