from sympy import symbols, simplify

c = symbols('c')
D = 1 + c - c ** 2
expr = (1 - c) * (c * D - c ** 2) - c * D ** 2
print(expr)  # -c*(-c**2 + c + 1)**2 + (1 - c)*(-c**2 + c*(-c**2 + c + 1))
res = simplify(expr)
print(res)  # c**2*(-c**3 + 3*c**2 - 3)
