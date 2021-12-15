# PBVI_verilog
homework for DI

## 实现
实现2状态(Left,Right)，3行动(Open-left, Open-right, Listen)，16信念点（定点数表示，分别为$1/32,3/32,...,31/32$），决策深度为5

> 可能的扩展，增加信念点的数目，增加决策深度
## 分工
首先先对于代码进行实现，按照求解的步骤进行分工，最后一个人来实现最终的整合过程
### Step 1
为每个action-observation构造中间体$\alpha_i^{a,o}(s)$
$$
\Gamma^{\alpha,o} \leftarrow \alpha_i^{a,o}(s) = \gamma\sum_{s'\in S}T(s,a,s')\Omega(o,s',a)\alpha_i'(s')
$$
可能的实际实现，8组并行的计算过程，每组对于16个信念点进行两点的乘累加操作
### Step 2
对于观测点进行决策模拟，将决策降维至行为级
$$
\begin{aligned}
i(b,o) = arg\max_{i}(\{\alpha^{a,o}_i(s_0),\alpha^{a,o}_i(s_1)\}\cdot b)
\end{aligned}
$$
$$\Gamma^a_b = \{R(s_0,a) + \sum_{o\in O}\alpha_{i(b,o)}^{a,o}(s_0),R(s_1,a) + \sum_{o\in O}\alpha_{i(b,o)}^{a,o}(s_1)\}$$

### Step 3
对于已有的$\Gamma^a_b$，选择最合适的行为并得到最后的$\alpha_i(s)$
$$a(b) = arg \max_{a\in A}(\Gamma^a_b\cdot b)$$
$$\alpha_i(s) = \Gamma^{a(b)}_b(i,s)$$

### 整合

对于所有step的内容进行连接，并搭建测试框架
