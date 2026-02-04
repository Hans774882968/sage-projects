# sqrt(1 + (sqrt(2) - 5/4) ^ 0.25)
S.<x> = PolynomialRing(QQ, order='lex')
eq = ((x ^ 2 - 1) ^ 4 + 5 / 4) ^ 2 - 2
eq_factor = eq.factor()
print(eq, eq_factor)
# (x^8 - 4*x^6 - 2*x^5 + 6*x^4 + 6*x^3 - 2*x^2 - 5*x - 7/4) * (x^8 - 4*x^6 + 2*x^5 + 6*x^4 - 6*x^3 - 2*x^2 + 5*x - 7/4)
# 可以写成 f(x) * f(-x) = 0
eq1 = x ^ 8 - 4 * x ^ 6 - 2 * x ^ 5 + 6 * x ^ 4 + 6 * x ^ 3 - 2 * x ^ 2 - 5 * x - 7 / 4
sols = solve(SR(eq1), SR(x))  # 解方程失败
# sols = SR(eq1).roots()  # RuntimeError: no explicit roots found
print(sols)
# 画出函数图像，可以看到两个数值解。但这意义不大，因为猜不到数值解的解析形式
