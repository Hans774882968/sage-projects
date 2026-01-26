R.<a, b, c> = PolynomialRing(QQ, order='lex')
eq1 = a - a * b - c
eq2 = b - b * c - a
eq3 = c - c * a - b
G = ideal(eq1, eq2, eq3).groebner_basis()
print(G)  # [a - c^4 + 3*c^3 - c^2 - c, b + c^3 - 2*c^2 - c, c^5 - 3*c^4 + 3*c^2]
c_poly = G[-1].factor()
print(c_poly)  # c^2 * (c^3 - 3*c^2 + 3)

a_expr = a - G[0]
b_expr = b - G[1]
wanted = a_expr + b_expr + c
print(wanted)  # c^4 - 4*c^3 + 3*c^2 + 3*c

f = c ^ 3 - 3 * c ^ 2 + 3

'''
# 通义千问生成的没用的代码。输出： a^4 - 4*a^3 + 3*a^2 + 3*a
S = R.quotient(f, 'cbar')  # 商环 Q[c] / (c^3 - 3c^2 + 3)
cbar = S.gen()  # 商环中的 c
expr_reduced = wanted.subs(c=cbar)  # 将 expr 映射到商环
print("Reduced expression in quotient ring:", expr_reduced.lift())  # lift 回原环
'''

quotient = wanted // f
ans = wanted % f
print('商：', quotient, '答案：', ans)

print('验算： (c - 1) * f + 3 确实等于 wanted', (c - 1) * f + 3 == wanted)

# 验证之前解法的关键结果
key_expr = (1 - a_expr) * (1 - b_expr) * (1 - c)
print(key_expr)  # c^8 - 6*c^7 + 11*c^6 - 3*c^5 - 10*c^4 + 9*c^3 - 3*c + 1
key_expr_mod = key_expr % f
print(key_expr_mod)  # 确实是1
