R.<t, x, y> = PolynomialRing(QQ, order='lex')
f = (x + 1) * (y + 2) + t * (x ^ 2 + y ^ 2 - 1)
fdx = diff(f, x)
fdy = diff(f, y)
fdt = diff(f, t)
print(fdx, fdy, fdt)  # 2*t*x + y + 2 2*t*y + x + 1 x^2 + y^2 - 1
I = ideal(fdx, fdy, fdt).groebner_basis()
print(I)
'''
[t + 2*y^3 + 4*y^2 + 3/2*y - 1, x - 2*y^2 - 2*y + 1, y^4 + 2*y^3 + 1/4*y^2 - y]
'''

y_func_factor = I[2].factor()
print(y_func_factor)
'''
(1/4) * y * (4*y^3 + 8*y^2 + y - 4)
'''

y = var('y')
sols = solve(y ^ 3 + 2 * y ^ 2 + 1 / 4 * y - 1)
print(sols)
'''
[
    y == -1/12*(3*sqrt(61)*sqrt(3) + 62)^(1/3)*(I*sqrt(3) + 1) - 13/12*(-I*sqrt(3) + 1)/(3*sqrt(61)*sqrt(3) + 62)^(1/3) - 2/3,
    y == -1/12*(3*sqrt(61)*sqrt(3) + 62)^(1/3)*(-I*sqrt(3) + 1) - 13/12*(I*sqrt(3) + 1)/(3*sqrt(61)*sqrt(3) + 62)^(1/3) - 2/3,
    y == 1/6*(3*sqrt(61)*sqrt(3) + 62)^(1/3) + 13/6/(3*sqrt(61)*sqrt(3) + 62)^(1/3) - 2/3
]
# 像下面这么写，求单变量多项式的根，也是OK的
y_func_sym = y ^ 3 + 2 * y ^ 2 + 1 / 4 * y - 1
sols = y_func_sym.roots()
wanted_y = sols[2][0]
'''

wanted_y = sols[2].rhs()
wanted_y_n = wanted_y.n()
x = 2 * y ^ 2 + 2 * y - 1
wanted_x_n = x.subs(y=wanted_y).n()
goal = (x + 1) * (y + 2)
ans = goal.subs(y=wanted_y)
ans_simplified = ans.simplify_full()
n_ans = ans.n()
print(f'已吓哭~\nx的数值解 = {wanted_x_n}\ny的数值解 = {wanted_y_n}\n{latex(wanted_y)}\nans = {ans}\n{latex(ans)}\n{latex(ans_simplified)}\n{n_ans}')
r'''
已吓哭~
x的数值解 = 0.817182646506771
y的数值解 = 0.576378801005197
\frac{1}{6} \, {\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}} + \frac{13}{6 \, {\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}}} - \frac{2}{3}
ans = 1/108*(((3*sqrt(61)*sqrt(3) + 62)^(1/3) + 13/(3*sqrt(61)*sqrt(3) + 62)^(1/3) - 4)^2 + 6*(3*sqrt(61)*sqrt(3) + 62)^(1/3) + 78/(3*sqrt(61)*sqrt(3) + 62)^(1/3) - 24)*((3*sqrt(61)*sqrt(3) + 62)^(1/3) + 13/(3*sqrt(61)*sqrt(3) + 62)^(1/3) + 8)
\frac{1}{108} \, {\left({\left({\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}} + \frac{13}{{\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}}} - 4\right)}^{2} + 6 \, {\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}} + \frac{78}{{\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}}} - 24\right)} {\left({\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}} + \frac{13}{{\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{1}{3}}} + 8\right)}
\frac{{\left(5 \, \sqrt{61} \sqrt{3} + 216\right)} {\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{2}{3}} + 24 \, {\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{4}{3}} + 313 \, \sqrt{61} \sqrt{3} + 5004}{12 \, {\left(3 \, \sqrt{61} \sqrt{3} + 62\right)}^{\frac{4}{3}}}
4.68175084801457
'''
