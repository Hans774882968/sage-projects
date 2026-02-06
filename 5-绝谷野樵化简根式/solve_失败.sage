S.<a, b, c, d> = PolynomialRing(QQ, order='lex')
K.<sqrt2, sqrt3> = NumberField([x ^ 2 - 2, x ^ 2 - 3])
sqrt6 = sqrt2 * sqrt3
expr = a + b * sqrt2 + c * sqrt3 + d * sqrt6
expanded = expr ^ 3

# 将 expanded 表示为 Q(sqrt2, sqrt3) 中的线性组合
# Sage 会自动将其写成 A + B*sqrt2 + C*sqrt3 + D*sqrt6 的形式
# 提取系数
# k1 = expanded.polynomial().coefficient({sqrt2:0, sqrt3:0})          # 常数项
# k2 = expanded.polynomial().coefficient({sqrt2:1, sqrt3:0})          # sqrt2 的系数
# k3 = expanded.polynomial().coefficient({sqrt2:0, sqrt3:1})          # sqrt3 的系数
# k4 = expanded.polynomial().coefficient({sqrt2:1, sqrt3:1})          # sqrt2*sqrt3 = sqrt6 的系数

# 这个文件不管怎么改都是失败。 vector_space, absolute_vector_space, relative_vector_space 都失败
# 这里作为失败的尝试保留下来
# 成功的尝试见 5-绝谷野樵化简根式/sqrt_exp.sage
V, from_V, to_V = K.relative_vector_space()
vec = to_V(expanded)

v1 = vec[0]
v2 = vec[1]
v3 = vec[2]
v4 = vec[3]

print("v1 =", v1)
print("v2 =", v2)
print("v3 =", v3)
print("v4 =", v4)

I = S.ideal([v1, v2, v3, v4])
G = I.groebner_basis()

for g in G:
    print(g)
