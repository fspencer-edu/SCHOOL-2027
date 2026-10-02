
Run setup procedure
        ↓
read mx.lmimx_log
        ↓
find eligible PART_IDs
        ↓
PART_ID = running
        ↓
run input procedure
        ↓
build/reuse partition snapshot
        ↓
detect all fixed T slices
        ↓
solve every slice sequentially
        ↓
write each converged slice to mx.lmimx_gpu_result
        ↓
writer.drain()
        ↓
call output procedure once
        ↓
lfs.lfs3m3xpr_mx finalized
        ↓
import log updated
        ↓
staging table cleared
        ↓
PART_ID = complete


## Basic Example

Assume a parent value:

$$  
P = 100  
$$

with three children:

$$  
x = (20, 30, 40)  
$$

The children currently sum to:

$$  
20 + 30 + 40 = 90  
$$

so the hierarchy has a difference of:

$$  
d = P - \sum_i x_i = 100 - 90 = 10  
$$

The goal is to adjust the children so that:

$$  
\sum_i x_i = P  
$$

while respecting any `MIN` and `MAX` restrictions.

---

# 1. Original SQL Iterative Method

The original SQL approach calculates the difference between the parent and its children:

$$  
d = P - \sum_i x_i  
$$

For the example:

$$  
d = 100 - 90 = 10  
$$

If the difference is distributed equally across $n$ children:

$$  
\Delta_i = \frac{d}{n}  
$$

therefore:

$$  
\Delta_i = \frac{10}{3} = 3.333  
$$

and:

$$  
(20,30,40)  
\rightarrow  
(23.33,33.33,43.33)  
$$

Now:

$$  
23.33 + 33.33 + 43.33 \approx 100  
$$

Conceptually:

$$  
x^{(k+1)} = F\left(x^{(k)}\right)  
$$

where $F$ represents the SQL correction logic.

## Main Problem

The same MX cell can participate in several hierarchies.

```
Fix Geography
      ↓
Fix Industry
      ↓
Industry changes cells used by Geography
      ↓
Fix Occupation
      ↓
Occupation changes cells used by both
      ↓
Repeat
```

Therefore, fixing one hierarchy can break another.

This can produce oscillation:

$$  
0.40  
\rightarrow  
0.25  
\rightarrow  
0.20  
\rightarrow  
0.24  
\rightarrow  
0.19  
\rightarrow  
0.23  
\rightarrow  
\cdots  
$$

The SQL procedure performs **local corrections without solving all constraints simultaneously**

---

# 2. Iterative Proportional Fitting — IPF / Raking

IPF uses **multiplicative scaling** rather than additive redistribution.

Calculate the scaling ratio:

$$  
r = \frac{P}{\sum_i x_i}  
$$

For the example:

$$  
r = \frac{100}{90} = 1.1111  
$$

Then:

$$  
x_i' = r x_i  
$$

giving:

$$  
(20,30,40)  
\rightarrow  
(22.22,33.33,44.44)  
$$

and approximately:

$$  
22.22 + 33.33 + 44.44 = 99.99 \approx 100  
$$

The important feature is that the proportions are preserved:

$$

22.22:33.33:44.44  
$$

For several dimensions, the process repeatedly adjusts the different margins:

```
Geography
    ↓
Industry
    ↓
Occupation
    ↓
Geography
    ↓
   ...
```

until the margins converge.

### Advantages

- Simple
- Preserves relative proportions
- Useful for marginal totals
- Common in statistical reconciliation
    
### Limitation for MX

Explicit `MIN` and `MAX` restrictions make ordinary IPF more complicated.

---

# 3. Successive Projections

Successive projections treat each hierarchy as a **mathematical constraint**.

For example:

$$  
x_1 + x_2 + x_3 = 100  
$$

defines the valid set:

$$
C_1 =
\left\{
x \mid x_1 + x_2 + x_3 = 100
\right\}
$$

A projection asks:

> What is the closest point to the current values that satisfies this constraint?

Mathematically:

$$
P_C(y)
=
\arg\min_{x \in C}
\left\|x-y\right\|_2^2
$$

The update is:

$$
x^{(k+1)}
=
P_{C_i}\left(x^{(k)}\right)
$$

For several constraints:

$$  
P_{C_1}  
\rightarrow  
P_{C_2}  
\rightarrow  
P_{C_3}  
\rightarrow  
\cdots  
$$

The distinction from SQL is important:

**SQL:** applies a custom redistribution rule.

**Projection:** finds the mathematically closest point satisfying a constraint.

---

# 4. Dykstra's Algorithm

Dykstra improves successive projections by remembering the correction associated with each constraint.

For constraint $i$:

$$  
y = x + p_i  
$$

where $p_i$ is the stored correction.

Project onto the constraint:

$$  
x' = P_{C_i}(y)  
$$

Then update the correction:

$$  
p_i' = y - x'  
$$

Each constraint therefore retains information about its previous adjustment.

Conceptually:

```
Constraint C₁ + memory p₁
          ↓
Constraint C₂ + memory p₂
          ↓
Constraint C₃ + memory p₃
          ↓
        Repeat
```

This helps prevent later projections from simply erasing information from earlier projections.

### Advantages

- Handles overlapping convex constraints
- Supports bound constraints
- Relatively simple
- Can exploit sparse hierarchy structures
    

---

# 5. Least-Squares Reconciliation

Instead of correcting one hierarchy at a time, reconciliation represents **all hierarchy relationships mathematically**.

Let:

$$  
x_0 = \text{original VALEST}  
$$

and:

$$  
x = \text{reconciled VALEST}  
$$

Represent all hierarchy constraints as:

$$  
Ax = b  
$$

Then solve:

$$  
\min_x  
\frac{1}{2}  
|x-x_0|_2^2  
$$

subject to:

$$  
Ax = b  
$$

This means:

> Find values satisfying all hierarchy relationships while changing the original MX values as little as possible.

---

# 6. Weighted Reconciliation

Some values may be more reliable or less alterable than others.

Introduce a weight matrix:

$$  
W =  
\begin{bmatrix}  
w_1 & 0 & 0 \  
0 & w_2 & 0 \  
0 & 0 & w_3  
\end{bmatrix}  
$$

Then solve:

$$  
\min_x  
\frac{1}{2}  
(x-x_0)^T  
W  
(x-x_0)  
$$

subject to:

$$  
Ax = b  
$$

If:

$$  
w_1 = 100  
$$

while:

$$  
w_3 = 1  
$$

then changing $x_1$ is much more expensive than changing $x_3$.

The solver therefore prefers to adjust $x_3$.

---

# 7. Bounded Quadratic Programming — QP

For MX, we also have `MIN` and `MAX` restrictions.

Let:

$$  
L = \text{MIN}  
$$

and:

$$  
U = \text{MAX}  
$$

The complete problem becomes:

$$  
\boxed{  
\begin{aligned}  
\min_x \quad &  
\frac{1}{2}(x-x_0)^T W(x-x_0) \  
\text{subject to} \quad &  
Ax = b \  
&  
L \leq x \leq U  
\end{aligned}  
}  
$$

This incorporates:

**Original values**

$$  
x_0  
$$

**Hierarchy constraints**

$$  
Ax = b  
$$

**Allowed ranges**

$$  
L \leq x \leq U  
$$

This is a **bounded weighted hierarchical reconciliation problem**.

---

# 8. ADMM

ADMM is a numerical algorithm that can solve large optimization problems by splitting them into smaller pieces.

Suppose the MX table contains several dimensions.

Define local solutions:

$$  
x_G = \text{Geography solution}  
$$

$$  
x_I = \text{Industry solution}  
$$

$$  
x_O = \text{Occupation solution}  
$$

Introduce a global consensus variable:

$$  
z  
$$

The local solutions should eventually agree with the global solution:

$$  
x_G = z,  
\qquad  
x_I = z,  
\qquad  
x_O = z  
$$

A simplified local ADMM update has the form:
$$
\arg\min_{x_i}  
\left[  
f_i(x_i)  
+  
\frac{\rho}{2}  
\left|  
x_i-z^{(k)}+u_i^{(k)}  
\right|_2^2  
\right]  
$$

The consensus variable is then updated from the local solutions:

$$  
z^{(k+1)}  
\approx  
\frac{1}{m}  
\sum_i  
\left(  
x_i^{(k+1)} + u_i^{(k)}  
\right)  
$$

The disagreement variable is updated using:
$$
z^{(k+1)}  
$$

Conceptually:

```
                    MX
                     │
       ┌─────────────┼─────────────┐
       ↓             ↓             ↓
   Geography      Industry     Occupation
       ↓             ↓             ↓
      xG            xI            xO
       └─────────────┼─────────────┘
                     ↓
                Consensus z
                     ↓
              Update disagreement
                     ↓
                   Repeat
```

ADMM is attractive for large MX problems because many local calculations can potentially be parallelized.

---

# 9. Dagum–Cholette / Statistical Reconciliation

A statistical reconciliation formulation starts with:

$$  
x = x_0 + \delta  
$$

where $\delta$ represents the adjustment to the original values.

The hierarchy requires:

$$  
Ax = b  
$$

Substitute $x=x_0+\delta$:

$$  
A(x_0+\delta)=b  
$$

Expanding:

$$  
Ax_0+A\delta=b  
$$

Therefore:

$$  
\boxed{  
A\delta=b-Ax_0  
}  
$$

The quantity:

$$  
b-Ax_0  
$$

represents the discrepancy in the original table.

We then find an appropriate adjustment $\delta$, for example:

$$  
\min_\delta  
\delta^T W\delta  
$$

subject to:

$$  
A\delta=b-Ax_0  
$$

This asks:

> What is the smallest or most statistically appropriate adjustment needed to reconcile the table?

---

# 10. Preserving Small Positive Values

MX also has the issue that small positive values may collapse to exactly zero.

Suppose:

$$  
x_i^0=0.01  
$$

and reconciliation changes it to:

$$  
x_i=0  
$$

This is a small **absolute** change:

$$  
|0.01-0|=0.01  
$$

but a very large **relative** change:

$$  
\frac{|0-0.01|}{0.01}=1=100%  
$$

Compare this with:

$$  
1000\rightarrow999  
$$

whose relative change is only:

# 0.001

0.1%  

One way to discourage small positive estimates from collapsing to zero is to use relative weights:

$$
w_i = \frac{1}{(x_i^0 + \epsilon)^2}
$$
where $\epsilon>0$ prevents division by zero.

The resulting objective is approximately:

$$  
\min_x  
\sum_i  
\left(  
\frac{x_i-x_i^0}  
{x_i^0+\epsilon}  
\right)^2  
$$

This penalizes **relative changes** rather than only absolute changes.

True structural zeros should be treated separately:

$$  
x_i=0  
\qquad  
\text{for structural zeros}  
$$

---

# Recommended Mathematical Model for MX

For MX, define:

$$  
x_0 = \text{original VALEST}  
$$

$$  
x = \text{final VALEST}  
$$

$$  
A = \text{sparse hierarchy constraint matrix}  
$$

$$  
b = \text{required hierarchy totals}  
$$

$$  
L = \text{MIN values}  
$$

$$  
U = \text{MAX values}  
$$

$$  
W = \text{alterability or reliability weights}  
$$

Then solve:

$$  
\boxed{  
\begin{aligned}  
\min_x \quad &  
\frac{1}{2}(x-x_0)^T W(x-x_0) \  
\text{subject to} \quad &  
Ax=b \  
&  
L\leq x\leq U  
\end{aligned}  
}  
$$

The important distinction is:

> **Reconciliation defines the mathematical problem.**

while:

> **QP, Dykstra, ADMM, G-Series, and other numerical methods provide ways to solve that problem.**

---

# Measuring Convergence

After solving, calculate the hierarchy residual:

$$  
r = Ax-b  
$$

The maximum hierarchy error is:

$$
\mathrm{DIFF\_AMT}
=
\lVert r \rVert_{\infty}
=
\max_i \left|r_i\right|
$$

For a tolerance $\epsilon$, count the number of hierarchy constraints that still fail:

$$
\mathrm{DIFF\_CT}
=
\sum_i
\mathbf{1}
\left(
\left|r_i\right| > \epsilon
\right)
$$
The hierarchy has converged when:

$$  
\boxed{  
DIFF_CT=0  
}  
$$

which is equivalent to:

$$  
\boxed{  
|Ax-b|_\infty\leq\epsilon  
}  
$$
# Overall Architecture

```
MariaDB
    ↓
Load VALEST / MIN / MAX
    ↓
Read variable dimensions
    ↓
Read variable hierarchy levels
    ↓
Generate sparse hierarchy constraints
        Ax = b
    ↓
Check feasibility
    ↓
Bounded weighted reconciliation
    ↓
Solver
    ├── G-Series
    ├── QP
    ├── Dykstra
    └── ADMM
    ↓
Calculate
    r = Ax - b
    ↓
Check
    DIFF_AMT
    DIFF_CT
    ↓
Write reconciled VALEST
    ↓
MariaDB
```

- Estimate code
	- 

- SQL
	- Proportional tree by tree balancing
- 0 -> kdigit

->publish -> mx_gpu_results


Hey Cheyenne — I found a few good StatCan resources on how G-Series handles reconciliation/balancing:

- [G-Series overview](https://statcan.r-universe.dev/articles/gseries/gseries.html)
    
- [Dagum & Cholette (2006)](https://statcan.github.io/gensol-gseries/en/articles/gseries.html) — main mathematical foundation
    
- [Quenneville & Fortier (2012)](https://statcan.github.io/gensol-gseries/en/reference/tsraking.html) — restoring accounting constraints
    
- [Bérubé & Fortier (2009)](https://statcan.github.io/gensol-gseries/en/reference/tsraking.html) — PROC TSRAKING / older SAS approach
    
- [Fortier & Quenneville (2009)](https://statcan.github.io/gensol-gseries/en/reference/tsraking.html) — reconciliation and balancing of accounts/time series
    

These should be useful for understanding the methods and convergence approach StatCan uses.